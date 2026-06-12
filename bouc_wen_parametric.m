function [u_max, z_max, fel_max, fh_max, xi_h, energy] = bouc_wen_parametric(A, alfa, beta, gamma, n, sismo, tf)
%------------ Funcion Bouc-Wen Parametric --------------------------------%
% Acorde los parámetros seleccionados A, alfa, beta, gamma, n del modelo  %
% de Bouc - Wen, la señal sísmica definida por sismo y el tiempo de       %
% duración del sismo definido por tf, se resuelve numéricamente el        %
% sistema de ecuaciones diferenciales de u(t) y z(t)                      %
% Se realiza medición de las deformaciones máximas y fuerza de            %
% restauración máximas lineal y no lineal. Y se realizan los gráficos     %
% Comparativos e ilustrativos de la histéresis del sistema                %

    %% == Parametros del sistema == %%
    % A, beta, gamma, n parametros de Bouc Wen 
    % alfa ponderacion elastico - plastica del sistema
    % sismo: nombre del registro sismico a usar

    % Características dinámicas del sistema 
    T = 1.0;                    %Periodo del sistema
    omega_n = 2 * pi / T;       % Frecuencia natural del sistema
    xi = 0.01;                  %Coeficiente de amortiguamiento
    
    % Condiciones iniciales
    u0 = 0;                     % Desplazamiento inicial (m)
    v0 = 0;                     % Velocidad inicial (m/s)
    z0 = 0;                     % Estado histerético inicial
    
    PGA = 0.70;                 % máx. acel. del suelo p/ escalar [%g]
    % Leer datos de aceleración del sismo:
    switch lower(sismo)
        case 'kobe'
            [time_data, xg] = datosTerremoto('Kobe-1995', 0.010, PGA);
            disp('Se usaran los datos del sismo de Kobe - 1995');
            % Ruta de la carpeta a usar
            outputFolder = 'C:\Users\victo\OneDrive\Documentos\MATLAB\randomResults_Kobe';
            % Titulo de los resultados
            sismoName = 'Kobe 1995';

        case 'lomaprieta'
            [time_data, xg] = datosTerremoto('LomaPrietaGilroy-1989', 0.0050, PGA);
            disp('Se usaran los datos del sismo de Loma Prieta Gilroy - 1989');
            % Ruta de la carpeta a usar
            outputFolder = 'C:\Users\victo\OneDrive\Documentos\MATLAB\randomResults_LomaPrieta';
            sismoName = 'Loma Prieta Gilroy 1998';

        case 'managua'
            [time_data, xg] = datosTerremoto('Managua-1972', 0.010, PGA);
            disp('Se usaran los datos del sismo de Managua - 1972');
            outputFolder = 'C:\Users\victo\OneDrive\Documentos\MATLAB\randomResults_Managua';
            sismoName = 'Managua 1972';

        case 'northridge'
            [time_data, xg] = datosTerremoto('Northridge-Sylmar1994', 0.020, PGA);
            disp('Se usaran los datos del sismo de Northridge-Sylmar 1994');
            % Ruta de la carpeta a usar
            outputFolder = 'C:\Users\victo\OneDrive\Documentos\MATLAB\randomResults_Northridge';
            % Titulo de los resultados
            sismoName = 'Northridge -  Sylmar 1994';

        case 'imperialvalley'
            [time_data, xg] = datosTerremoto('ImperialValley1940', 0.010, PGA);
            disp('Se usaran los datos del sismo de Imperial Valley 1940');
            % Ruta de la carpeta a usar
            outputFolder = 'C:\Users\victo\OneDrive\Documentos\MATLAB\randomResults_ImperialValley';
            % Titulo de los resultados
            sismoName = 'Imperial Valley 1940';

        otherwise 
            disp('Registros indicados no encontrados');
    end
    
    
    %% == Resolución numérica == %%
    tspan = [0 tf];         % Intervalo de tiempo
    % Configuracion del error de integracion
    options = odeset('RelTol', 1e-4,'AbsTol', 1e-6);
    
    % Sistema de ecuaciones diferenciales y parametros
    [t, sol] = ode15s(@(t, y) earthquake_bw_ode(t, y, xi, omega_n, alfa, n, A, beta, gamma, xg, time_data), tspan, [u0 v0 z0], options);
    
    u = sol(:, 1);                                         % Desplazamiento
    v = sol(:, 2);                                         % Velocidad
    z = sol(:, 3);                                         % Componente histerética
    
    f_el = alfa*(omega_n^2)* u;                            % Componente lineal de la fuerza
    f_h = (1-alfa)*(omega_n^2)*z;                          % Componente no lineal
    f_t = f_el + f_h;                                      % Fuerza de restauración no lineal
    

    %% == Interpretación de resultados == %%
    % Calcular coeficiente de restauracion asociado y energia disipada
    [xi_h, energy] = xi_histeresys(u,f_t);
    
    % Dezplamientos y fuerza de restauración máximos
    [fel_max,~] = max(abs(f_el));
    [fh_max,~] = max(abs(f_h));
    [u_max,~] = max(abs(u));
    [z_max,~] = max(abs(z));

    %---------------------- Graficos ---------------------------------
    % Crea la figura 1, sin mostrar el resultado en pantalla
    fig1 = figure('Visible', 'off');

    % Especificaciones de la figura 1: dimensiones y escala
    fig1.Position = [100, 100, 1920, 926];

    % Comparativo de desplazamiento lineal y componente de histeresis
    subplot(2,2,1);
    plot(t, u, 'k--', t, z, 'b-');
    xlabel('Tiempo [s]','Interpreter','latex');
    ylabel('Desplazamiento [m]','Interpreter','latex');
    title('Comparación entre los desplazamientos', sismoName);
    yline(0, '-r', 'LineWidth', 0.25);                     % Eje horizontal y = 0
    legend('$u(t)$', '$z(t)$','Location','SouthWest', 'Interpreter', 'latex')
    grid on;
    %-----------

    subplot(2,2,2);
    plot(t, f_el, 'k--', t, f_h, 'b-');
    xlabel('Tiempo [s]','Interpreter','latex');
    ylabel('Fuerza [kN]','Interpreter','latex');
    title('Comparación entre las fuerzas de restauración', sismoName);
    yline(0, '-r', 'LineWidth', 0.25);                     % Eje horizontal y = 0
    legend('$f_{el}(u)$', '$f_h (z)$', 'Location','SouthWest','Interpreter', 'latex')
    grid on;
    %---------------

    subplot(2,2,3);
    plot(u, f_h, 'b-');
    xlabel('$u(t)$ [m]','Interpreter','latex');
    ylabel('$f_{h}(z)$ [kN]','Interpreter','latex');
    title('Curva de histeresis');
    % Leyenda del grafico con los parametros
    % Leyenda del grafico con los parametros
    legendText = sprintf('$\\alpha = %.2f$\n$\\beta = %.2f$\n$\\gamma = %.2f$\n$n = %.2f$\n$\\xi_{hist} = %.2f$', alfa, beta, gamma, n, xi_h);
    % Agrega el texto como una anotación
    annotation('textbox', [0.40, 0.14, 0.1, 0.1], 'String', legendText, ...
           'Interpreter', 'latex', 'FitBoxToText', 'on', ...
           'BackgroundColor', 'white', 'EdgeColor', 'none');
    xline(0, '-r', 'LineWidth', 0.25);                      
    yline(0, '-r', 'LineWidth', 0.25);                      
    grid on;
    %----------------

    subplot(2,2,4);
    plot(u, f_t, 'k-');
    xlabel('$u(t)$ [m]','Interpreter','latex');
    ylabel(' $F(t)$ [kN]', 'Interpreter','latex');
    title('Fuerza de restauración total');
    % Leyenda del grafico con los parametros
    legendText = sprintf('$\\alpha = %.2f$\n$\\beta = %.2f$\n$\\gamma = %.2f$\n$n = %.2f$\n$\\xi_{hist} = %.2f$', alfa, beta, gamma, n, xi_h);
    % Agrega el texto como una anotación
    annotation('textbox', [0.84, 0.14, 0.1, 0.1], 'String', legendText, ...
           'Interpreter', 'latex', 'FitBoxToText', 'on', ...
           'BackgroundColor', 'white', 'EdgeColor', 'none');
    xline(0, '-r', 'LineWidth', 0.25);                      % Eje vertical x = 0
    yline(0, '-r', 'LineWidth', 0.25);                      % Eje horizontal y = 0
    grid on;
    %-------------
 
    
    % -------------   Guardar resultados -----------------
    
    % Ruta de la carpeta a usar
    % Nombre acorde a los parametros correspondientes
    filename = [sismo, 'BW_af_', num2str(alfa), '_bt_', num2str(beta), '_gm_', num2str(gamma), '_n_', num2str(n), '.png'];
    
    % Nombre completo del archivo, indicando ruta con outputFolder
    fullFileName = fullfile(outputFolder,filename);
    
    % Guarda el resultado de fig1 con el nombre indicado en fullFileName
    saveas(fig1, fullFileName);
    
    
    %---------------------------------------------------------------------
   
end