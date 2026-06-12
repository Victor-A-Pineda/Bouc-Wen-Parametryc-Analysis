% Cantidad de muestras aleatorias a tomar
samples = 400; 
%% == Variables y datos iniciales == %%
% Inicializacion de arreglos
u_max = zeros(samples,3);
z_max  = zeros(samples,3);
fel_max  = zeros(samples,3);
fh_max  = zeros(samples,3);
xi_h = zeros(samples,3);
energy = zeros(samples,3);

% Valor inicial para determinar numeros aleatorios
rng(30);

% Asignacion aleatoria de los parametros
A = 1;
[alfa, beta, gamma, n] = lhs_BW_paramether(samples);

%% == Resolución del sistema por muestra == %%
for i = 1:samples
    disp('Muestra numero ');%
    disp(i);%
    
    [u_max(i,1), z_max(i,1), fel_max(i,1), fh_max(i,1), xi_h(i,1), energy(i,1)] = bouc_wen_parametric(A, alfa(i), beta(i), gamma(i), n(i), 'kobe', 18);
    [u_max(i,2), z_max(i,2), fel_max(i,2), fh_max(i,2), xi_h(i,2), energy(i,2)] = bouc_wen_parametric(A, alfa(i), beta(i), gamma(i), n(i),'imperialvalley', 25);
    [u_max(i,3), z_max(i,3), fel_max(i,3), fh_max(i,3), xi_h(i,3), energy(i,3)] = bouc_wen_parametric(A, alfa(i), beta(i), gamma(i), n(i), 'managua',15);

end 

%% == Registro de respuestas y mediciones == %%
datos_Kobe = [alfa, beta, gamma, n, u_max(:,1), z_max(:,1), fel_max(:,1), fh_max(:,1), xi_h(:,1), energy(:,1)];
datos_ImperialValley = [alfa, beta, gamma, n, u_max(:,2), z_max(:,2), fel_max(:,2), fh_max(:,2), xi_h(:,2), energy(:,2)];
datos_Managua = [alfa, beta, gamma, n, u_max(:,3), z_max(:,3), fel_max(:,3), fh_max(:,3), xi_h(:,3), energy(:,3)];

headers = {'Parametro alfa', 'Parametro beta', 'Parametro gamma', 'Parametro n', 'Maxima deformacion u', 'Maximo desplazamiento virtual z', 'Maxima fuerza elastica', 'Maxima fuerza inelastica', 'xi_h', 'Energia perdida' };
outputFolder = 'C:\Users\victo\OneDrive\Documentos\MATLAB\Results';

% Kobe
filename = 'datos_Kobe.xlsx';
fullFileName = fullfile(outputFolder,filename);
T = array2table(datos_Kobe, 'VariableNames', headers);
writetable(T, fullFileName);

% Imperial  Valley
filename = 'datos_ImperialValley.xlsx';
fullFileName = fullfile(outputFolder,filename);
T = array2table(datos_ImperialValley, 'VariableNames', headers);
writetable(T, fullFileName);

% Imperial  Valley
filename = 'datos_Managua.xlsx';
fullFileName = fullfile(outputFolder,filename);
T = array2table(datos_Managua, 'VariableNames', headers);
writetable(T, fullFileName);
