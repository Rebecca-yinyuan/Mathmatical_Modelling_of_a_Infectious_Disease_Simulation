function [residual, L, k, t_0, A, B, Delta] = SEIR_optimisation_stage3(data)

% Set Delta as constant whereas 
% 
% Gamma = A * exp(B * t), 
% Beta = L / (1 + exp( (k) * (t - t_0))). 
%
% Solve for Delta, L, k, t_0, A, and B to minimise the residual. 

    S = data(:,1);
    E = data(:,2);
    I = data(:,3);
    R = data(:,4);
    N = S(1) + E(1) + I(1) + R(1);
    t = 0:length(S)-1;

    % Initial guess for parameters [L, k, t_0, A, B, Delta_ini]
    initial_guess = [1 + rand() * 0.01; 
        0.5 + rand() * 0.01; 
        10 + rand() * 0.01; 
        0.0075 + rand() * 0.01; 
        0.5 + rand() * 0.01; 
        1 + 0.01 * rand];

    % Fitting parameters
    [x, residual] = paramfit(initial_guess,t,S,E,I);
    L = x(1);
    k = x(2);
    t_0 = x(3);
    A = x(4);
    B = x(5);
    Delta = x(6);

    % Comparing solution to data
    % Initial conditions
    init_cond = [S(1) E(1) I(1)];
    [~,y] = ode45(@(t,y) ode_sys(t,y,L, k, t_0,A, B,Delta, N), t, init_cond);

    plot(t,S,'g.','MarkerSize',17); hold on;
    plot(t,E,'m.','MarkerSize',17);
    plot(t,I,'r.','MarkerSize',17);
    plot(t,R,'b.','MarkerSize',17);
    
    plot(t,y(:,1),'g-', 'LineWidth', 2);
    plot(t,y(:,2),'m-', 'LineWidth', 2);
    plot(t,y(:,3),'r-', 'LineWidth', 2);
    plot(t,ones(length(S),1)*N - y(:,2) - y(:,1) - y(:,3),'b-', 'LineWidth', 2);
    axis([0 length(I) 0 N]);
    xlabel('\fontsize{14}Time');
    ylabel('\fontsize{12}# Susceptible(g), Exposed(m), Infected(r), Recovered(b) people');
    title('\fontsize{14}SEIR Model Stage3: Set Beta as a logistic, Gamma as an exp and Delta as an unknown constant');
    hold off

    function [x,fval] = paramfit(init,t,S,E,I)
    % Find parameter values based on minimising least sum of squares. 
    % Input: init is a vector of initial guesses for the parameters.
    % Output: x is a vector of the fitted parameters.
    % fval is the value of the least sum of squares difference (to get an idea
    % of how close the solution of the ODE system is to the data).

        % Define function to fit to data
        fun = @(parameters)sseval(parameters);
        x0 = init;
        [x,fval] = fminsearch(fun,x0);

    end 

    function sse = sseval(parameters)
    % Calculating the sum of squares of the difference between the observed 
    % cumulative MASH attendance (I) and the solution to the SI model.  
    
        L_1 = parameters(1);
        k_1 = parameters(2);
        t_0_1 = parameters(3);
        A_1 = parameters(4);
        B_1 = parameters(5);
        delta_1 = parameters(6);
     
        t_int_1 = t;
        init_cond_1 = [S(1) E(1) I(1)];
        
        % Solve the ODE system
        [~,y_1] = ode45(@(t,y) ode_sys(t,y,L_1, k_1, t_0_1,A_1, B_1,delta_1,N), t_int_1, init_cond_1); 
        
        % Calculate the sum of squares difference
        if length(S) == length(y_1(:,1))
            
            sse = sum((S - y_1(:,1)).^2) + sum((E - y_1(:,2)).^2) + sum((I - y_1(:,3)).^2);
            
        else
            
            sse = 100000000;
            "error!?!" % this shouldn't happen
            
        end
    end

    function dydt = ode_sys(t, y, L, k, t_0, A, B, delta, NN)

    % dS / dt = - beta * S * I / N;
    % dE / dt = beta * S * I / N - delta * E;
    % dI / dt = delta * E - gamma * I;
    %
    % Inputs: 
    % y = [S E I];
    %
    % Note: Gamma = A * exp(B * t), Beta = L / (1 + exp( (k) * (t - t_0))). 

    dydt = [ - L / (1 + exp( (k) * (t - t_0))) * y(1) * y(3) / NN;
        L / (1 + exp( (k) * (t - t_0))) * y(1) * y(3) / NN - delta * y(2);
        delta * y(2) - A * exp(B * t) * y(3)];
    end

end