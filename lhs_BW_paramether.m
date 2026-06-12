function [alfa, beta, gamma, n] = lhs_BW_paramether(samples)
% Funcion que determina los parametros de Bouc -  Wen de forma aleatoria %
% en rangos previamente discretizados usando una estrategia de muestreo  %
% hipercubo latino                                                       %
% samples: total de puntos a considerar                                  %
% alfa, beta, gamma, n: parámetros del modelo de Bouc-Wen                %

%% == Rangos de cada parametro == %%
    range_alfa = [0.01, 0.5];
    range_beta = [0, 3];
    range_gamma = [-3, 3];
     range_n = [1, 2];

%% == Determinación de cada parámetro == %%
    lhs_Paramether = lhsdesign(samples,4,'Criterion','correlation');
    alfa = linearMap(lhs_Paramether(:,1), range_alfa);
    beta = linearMap(lhs_Paramether(:,2), range_beta);
    gamma = linearMap(lhs_Paramether(:,3), range_gamma);
    n  = linearMap(lhs_Paramether(:,4), range_n);
    
%% == Función auxiliar == %%
    function [x] = linearMap(x, range_x)
        % Funcion que realiza un mapeo lineal de las coordenadas del     %
        %  vector x, adaptandolas al valores definidos en range_x        %
        % asumiendo que las coordenadas de x estan en [0,1].             %
        y0 = range_x(1);
        y1 = range_x(2);

        x = (y1 - y0)*x + y0*ones(size(x));
    end 
end 