function Delta_array = SEIR_Delta_discrete(y_experi, Delta, Gamma_array)

% This function plots Delta(t) from the Handshake Game data using discrete 
% SEIR model: 
%
% Delta{n} = I_{n + 1} - I_{n} + Gamma_{n} * I_{n}/ E_{n}, 
% where n = 0 : (t_max - 1).
%
% Note: Here, the input Delta is a function handle in terms of t. This
% Delta is obtained from the optimisation stages. The input Gamma_array is
% the discrete Gamma(t). 

E = y_experi(:, 2);
I = y_experi(:, 3);
t_max = length(I) - 1;
t_scale = (0 : t_max - 1)';


% Initialize the Delta vector: 
Delta_array = ones([t_max - 1, 1]);

% Calculate Delta at each discrete time: 
for i = 1 : t_max 
    
    I_old = I(i);
    I_new = I(i + 1);
    E_n = E(i);
    Gamma_n = Gamma_array(i);
    
    Delta_array_n = (I_new - I_old + I_old * Gamma_n) / E_n;
    Delta_array(i) = Delta_array_n;
    
end

% Plot Delta over time: 
figure(300);
plot(t_scale, Delta_array, 'ko');
title('\fontsize{14}Delta Over Time From Data VS Delta obtained from optimisation');
xlabel('\fontsize{16}Time');
ylabel('\fontsize{16}Delta');
hold on

% Plot Delta obtained from optimisation on the same figure: 
fplot(Delta, [0 t_max], 'LineWidth', 2);
hold off

end