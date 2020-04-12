function Gamma_array = Gamma_discrete(y_experi, Gamma)

% This function plots Gamma(t) from the Handshake Game data using discrete 
% SIR model: 
%
% Gamma_{n} = (R_{n + 1} - R_{n}) / I_{n}, where n = 0 : (t_max - 1).
%
% Note: Here, the input Gamma is a function handle in terms of t. This
% Gamma is obtained through optimisation stages. 

I = y_experi(:, 2);
R = y_experi(:, 3);
t_max = length(I) - 1;
t_scale = (0 : t_max - 1)';

% Initialize the Gamma vector: 
Gamma_array = ones([t_max - 1, 1]);

% Calculate Gamma at each discrete time: 
for i = 1 : t_max 
    
    R_old = R(i);
    R_new = R(i + 1);
    I_n = I(i);
    
    Gamma_array_n = (R_new - R_old) / I_n;
    Gamma_array(i) = Gamma_array_n;
    
end

% Plot Gamma over time: 
figure(100);
plot(t_scale, Gamma_array, 'ro');
title('\fontsize{14}Gamma Over Time From Data VS Gamma obtained from optimisation');
xlabel('\fontsize{16}Time');
ylabel('\fontsize{16}Gamma');
hold on

% Plot Gamma obtained from optimisation on the same figure: 
fplot(Gamma, [0 t_max], 'LineWidth', 2);
hold off

end