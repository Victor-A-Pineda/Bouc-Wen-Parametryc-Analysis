function [t, xg] = datosTerremoto(nombreTerremoto, dt, PGA)
    %----------- Función auxiliar: datosTerremoto ---------------------   %
    % Considerando el nombre del terremoto, el intervalo de tiempo de sus %
    % mediciones (dt) y el índice de máxima aceleración de suelo (PGA)    %
    % realiza la lectura y escalamiento de los datos de aceleración del   %
    % sismo, dando en respuesta dos vectores:                             %
    % t = Intervalos de tiempo donde se realizan las mediciones           %
    % xg = Medición de la aceleración del terremoto registrada            %
    % Adaptado de: Luis E. Suárez por Victor Pineda                       %
    
    %------------------- Datos del registro sísmico -----------------------
    addpath('C:\Users\victo\OneDrive\Documentos\Proyecto\Data')
    nom = nombreTerremoto;                   % nombre del archivo con acelerograma
    %dt                                      % intervalo de tiempo constante [seg]
    %PGA                                     % máx. acel. del suelo p/ escalar [%g]
    
    %------------------- Unidades a utilizar ------------------------------
    npt  = 1.0;                              % fracción (de 0 a 1) de puntos para graficar
    
    uni = 'SI';                              % sistema de unidades a usar: 'fps'o 'SI'

    ureg = 'g';                              % unidades de acel. [g,mm/s^2,cm/s^2,ft/s^2,etc]
    rec  = 'otro';                           % índice p/usar registros de: 'PRSMP' u 'otro'
    ies  = 'Si';                             % índice p/escalar registro: 'Si' o No'
    
    
    
    % --------- Lectura y escalamiento del acelerograma original -------------------
    
    terr = load ([nom,'.txt']);             % lectura del archivo con el registro
    [nr,nc]  = size(terr);                  % filas y columnas del archivo
    nt       = nr*nc;                       % nro. de puntos del acelerograma
    xg(1:nt) = terr';                       % vector con los datos del archivo
    
    
    switch uni                              % se escoge el valor de g
        case 'fps'
            g  = 386.4;                      % g = 386.4 in/s^2 para fps
            uV = 'kip';                      % imprime cortante en kip
            uu = 'pulg';                     % imprime desplazamiento en pulgadas
        case 'SI'
            g  = 9.81;                       % g = 9.81 m/s^2 para SI
            uV = 'kN';                       % imprime cortante en kip
            uu = 'cm';                       % imprime desplazamiento en cm
    end
    
    switch ureg                             % se cambia el registro a fracc. de g                  
        case 'mm/s^2'
            xg = xg/9810;                   % se divide el registro por g en mm/s^2
        case 'cm/s^2'
            xg = xg/981;                    % se divide el registro por g en cm/s^2
        case 'm/s^2'
            xg = xg/9.81;                   % se divide el registro por g en m/s^2
        case 'in/s^2'
            xg = xg/386.4;                  % se divide el registro por g en in/s^2
        case 'ft/s^2'
            xg = xg/32.2;                   % se divide el registro por g en ft/s^2
        otherwise
            %disp('==> NOTA: Se supone que el registro está en fracciones de g'); 
            disp(' ')
    end
    
    if strcmp(rec,'PRSMP')                  % se adapta el registro del PRSMP
        ni = round(60.5/dt);                % punto inicial para eliminar zona muerta
        nf = round(85/dt);                  % punto final para eliminar parte final
        xg = xg(ni:nf);                     % registro de aceler. cortado al comienzo y final
        xg = detrend(xg,2);                 % corrección de línea de base
    end
    
    nt = length(xg);                        % nro. de puntos del registro
    xm = max(abs(xg));                      % PGA original del acelerograma
    if  strcmp(ies,'Si')
        xg  = PGA/xm * xg; 	                % se escala el acelerograma al PGA dato
    end
    if  strcmp(ies,'No')
        PGA = xm;                           % se asigna como PGA el original
    end
    
    tf  = (nt-1) * dt;                      % tiempo final del registro
    t   = 0: dt: tf;                        % vector con tiempos discretos
    ng  = round(npt*nt);                    % número de puntos para graficar
    
    
    
    xg = xg*g;                              % Re-escalamiento de las medicion de la aceleracion
    
  
end