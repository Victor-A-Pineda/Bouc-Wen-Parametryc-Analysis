% Modelo de Bouc-Wen
% Algoritmo para verificar el funcionamiento del calculo de 
% xi_h con respecto a la cantidad de datos que se consideren de los ciclos
% de histeresis

%% == Resolución del sistema == %%
% Parámetros del sistema
T = 1.0;                    %Periodo del sistema
omega_n = 2 * pi / T;       % Frecuencia natural del sistema
xi = 0.01;                  %Coeficiente de amortiguamiento


% Curva seleccionada
A = 1;                    % Parámetro Bouc-Wen
beta = 2.62125;                 % Parámetro Bouc-Wen
gamma = 2.2275;                % Parámetro Bouc-Wen
n = 1.01625;                      % Parámetro Bouc-Wen
alfa = 0.3425875;                 %Ponderacion elasticidad - histeresis

% Condiciones iniciales
u0 = 0;                     % Desplazamiento inicial (m)
v0 = 0;                     % Velocidad inicial (m/s)
z0 = 0;                     % Estado histerético inicial

% Fuerza externa (N)
PGA = 0.7;
[time_data, xg] = datosTerremoto('Kobe-1995', 0.010, PGA);


% Intervalo de tiempo
tspan = [0 20];

% Resolver el sistema
% Usando datos de acelerometro
[t, sol] = ode45(@(t, y) earthquake_bw_ode(t, y, xi, omega_n, alfa, n, A, beta, gamma, xg, time_data), tspan, [u0 v0 z0]);

%----------------- Interpretacion de resultados -----------------------
 u = sol(:, 1);             % Desplazamiento
 v = sol(:, 2);             % Velocidad
 z = sol(:, 3);             % Componente histerética

f_el = alfa*(omega_n^2)* u;                          % Componente lineal de la fuerza
f_h = (1-alfa)*(omega_n^2)*z;                       % Componente no lineal
f_t = f_el + f_h;                                    % Total


%% == Análisis de resultados == %%
data = length(u);
xi_h = zeros(1);
energy = zeros(1);

% Posicion de intervalos temporales
i = ones(11,1);
for j=1:10
    while (t(i(j,1))<=10+j-1)
    i(j,1) = i(j,1)+1;
    end
    i(j+1,1)=i(j,1);
end
i(11,1) = length(t);

figure(4)
for j=1:10
    [xi_h(j), energy(j)] = xi_histeresys(u(1:i(j)),f_h(1:i(j)));
    subplot(2,5,j)
    plot(u(1:i(j)),f_h(1:i(j)));
    grid on
end
[xi_h(11), energy(11)] = xi_histeresys(u,z);

figure(5)
plot(10:20,xi_h,10:20,energy);

% for i=1:20:401
%     % Determinando xi_h excluyendo datos
%     [xi_h(j), energy(j)] = xi_histeresys(u(i:data,:),z(i:data,:));
% 
% 
%     j = j +1;
% end 
% 
% diff_xih = abs(xi_h - xi_h(1)*ones(size(xi_h)))/xi_h(1);
% 
% 
% log_xi = log(diff_xih);
% log_xi(1) = 0;
% 
% figure(j+1)
% plot(0:20:400,diff_xih, 'b-');
% xlabel('Datos no considerados');
% ylabel('Diferencia relativa \xi_{hist}');
% title('Comportamiento del parámetro de restauración');
% grid on;
% 
% figure(j+2)
% plot(0:20:400,log_xi, 'b-');
% xlabel('Datos no considerados');
% ylabel('Escala logarítmica de la diferencia (\xi_{hist})');
% title('Comportamiento del parámetro de restauración');
% grid on;


