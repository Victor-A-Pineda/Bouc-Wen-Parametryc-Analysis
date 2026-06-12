function dydt = earthquake_bw_ode(t, y, xi, omega_n, alfa, n, A, beta, gamma, xg, time_data)
% ------------- Función auxiliar: earthqueake - Bouc Wen Model -----------%
% Contiene el sistema de ecuaciones diferenciales linealizado donde       %
% x: representa la deformación del sistema o desplazamiento               %
% v: la velocidad de la deformación                                       %
% z: Dezplamiento virtual propuesto por Bouc-Wen                          %
% Las entradas de la función son:                                         %
% t: variable temporal símbolica                                          %
% y: vector de componentes (x,v,z)                                        %
% xi, omega_n: definen propiedades dinámicas del sistema                  %
% alfa, n, A, beta, gamma: Parámetros del modelo de Bouc-Wen              %
% xg, time_data: Aceleración y tiempos donde se realizo la medición       %


    x = y(1);               % Desplazamiento
    v = y(2);               % Velocidad
    z = y(3);               % Componente histerética
    
    
    a_s = interp1(time_data, xg, t, 'linear', 0);           % Interpolacion de los datos de aceleracion

    % Sistema de ecuaciones diferenciales
    dxdt = v;                                                                       % Velocidad
    dvdt = -a_s - 2*xi*omega_n * v - alfa*(omega_n^2)* x - (1-alfa)*(omega_n^2)*z;  % Aceleración                                                             
    dzdt = A * v - beta * abs(v) * abs(z)^(n-1) *z - gamma * v * abs(z)^n;          % Componente de histéresis
    
    % Salida
    dydt = [dxdt; dvdt; dzdt];
end