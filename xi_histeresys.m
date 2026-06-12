function[xi_h, energy] = xi_histeresys(u,z)
%--------------- Función auxiliar xi - histéresis -------------------------
% Calcula el coeficiente de amortiguamiento efectiva en el ciclo de       %
% histéresis presente en la fuerza de restauración del sistema            %
% Entradas:                                                               %
%   u: desplazamientos del sistema en metros                              %
%   z: fuerza de restauracion no lineal que genera el ciclo de histeresis %
% Salidas:                                                                %
%   xi_h: Coeficiente de amortiguamiento efectivo en el ciclo             %
%   energy: Energia disipada o perdida en el ciclo de histéresis          %

    [maxz, fila_z_max] = max(z);
    maxu = u(fila_z_max,1);
    area_max = 0.5*maxu*maxz;                               % Area del triangulo origen - vertice maximo, kN*m
    energy = polyarea(u,z);                                 % Area bajo la curva del ciclo, kN*m

% Validacion para evitar division por cero
        if area_max == 0
            disp('Hay division por cero');
            xi_h = 0;
            return;
        else 
            xi_h = (1/(4*pi))*(energy/(area_max));               % Parametro xi en histeresis
        end  
end