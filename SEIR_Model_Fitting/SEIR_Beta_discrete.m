function Beta_array = SEIR_Beta_discrete(y_experi, Beta)

% This function plots Beta(t) from the Handshake Game data using discrete 
% SEIR model: 
%
% Beta{n} = (S_{n} - S_{n + 1}) * N / (I_{n} * S_{n}), 
% where n = 0 : (t_max - 1).
%
% Note: Here, the input Beta is a function handle in terms of t. This Beta
% is obtained from the optimisation stages. 

S = y_experi(:, 1);
E = y_experi(:, 2);
I = y_experi(:, 3);
R = y_experi(:, 4);
t_max = length(I) - 1;
t_scale = (0 : t_max - 1)';
N = S(1) + E(1) + I(1) + R(1);

% Initialize the Beta vector: 
Beta_array = ones([t_max - 1, 1]);

% Calculate Beta at each discrete time: 
for i = 1 : t_max 
    
    S_old = S(i);
    S_new = S(i + 1);
    I_n = I(i);
    
    Beta_array_n = ((S_old - S_new) * N) / (I_n * S_old);
    Beta_array(i) = Beta_array_n;
    
end

% Plot Beta over time: 
figure(200);
plot(t_scale, Beta_array, 'bo');
title('\fontsize{14}Beta Over Time From Data VS Beta obtained from optimisation');
xlabel('\fontsize{16}Time');
ylabel('\fontsize{16}Beta');
hold on

% Plot Beta obtained from optimisation on the same figure: 
fplot(Beta, [0 t_max], 'LineWidth', 2);
hold off

end
