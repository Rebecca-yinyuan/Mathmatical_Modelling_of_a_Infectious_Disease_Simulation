function driver_SEIR_model_fitting

% For figure (1) - (18):
%
% Parameter Configuration: 
% total # people = 300;
% # handshakes = 10;
% infectious peroid = 5;
% # initial infectives = 1.
%
% NOTE: This driver only analyse the LargeUni data. Feel free to add codes
% to analyse the SmallUni as well as Highschool data. 

clc

% Import data from test files: 
[largeUni, smallUni, HighSchool] = import_data_from_txt_files();

% For 'LargeUni': 
num_data_set_1 = 18;


for i  = 1 : num_data_set_1
    
    figure(i); 
    SEIR_data = SIR_2_SEIR(largeUni{i});
        
    % Set Delta as constant whereas Gamma = A * exp(B * t), Beta = L / (1 + exp( (k) * (t - t_0))). 
    [residual, L, k, t_0, A, B, Delta] = SEIR_optimisation_stage3(SEIR_data)
    fprintf('\n*******************************************************************\n');
    
    
    % To see how our Beta, Gamma, and Delta obtained from the optimisation
    % stage behaves: 
    % Beta_array = SEIR_Beta_discrete(SEIR_data, @(t) L / (1 + exp( (k) * (t - t_0)))); 
    % Gamma_array = SEIR_Gamma_discrete(SEIR_data, @(t) A * exp(B * t));
    % Delta_array = SEIR_Delta_discrete(SEIR_data, @(t) Delta, Gamma_array);
    
end

end

