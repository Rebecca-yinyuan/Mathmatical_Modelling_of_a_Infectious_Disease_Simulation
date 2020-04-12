function [fval,k, L, t_0, Gamma] = parameters_optimisation_stage3(data)

% Optimisation Stage 3: 
%   Set Beta = L / (1 + exp(k * (t - t_0))) and Gamma as constant. 
%   Solve for L, k, t_0, and Gamma to minimise the residual.
%   Here, the output fval is the residual we obtained. 

    S = data(:,1);
    I = data(:,2);
    R = data(:,3);
    N = S(1) + I(1) + R(1);
    t = 0:length(S) - 1;


    % Initial guess for [k, L, t_0, Gamma] 
    initial_guess = ...
        [0.5 + rand() * 0.01; 
        2 + rand() * 0.01; 
        10 + rand() * 0.01; 
        0.75 + rand() * 0.01];

    % Fitting parameters
    [x, fval] = paramfit(initial_guess,t,S,I);
    k = x(1);
    L = x(2);
    t_0 = x(3);
    Gamma = x(4);

    % Initial conditions
    init_cond = [S(1) I(1)];
    [~,y] = ode15s(@(t,y) ode_sys(t, y, k, L, t_0, Gamma, N), t, init_cond);
    
    % Plot the result
    plot(t,I,'r.','MarkerSize',17);
    hold on
    plot(t,S,'g.','MarkerSize',17);
    plot(t,R,'b.','MarkerSize',17);
    plot(t,y(:,1),'g-','LineWidth', 2);
    plot(t,y(:,2),'r-', 'LineWidth', 2);
    plot(t,ones(length(S),1)*N - y(:,2) - y(:,1),'b-', 'LineWidth', 2);
    axis([0 length(I) 0 N]);
    xlabel('\fontsize{14}Time');
    ylabel('\fontsize{12}# Susceptible(green), Infected(red), Recovered(blue) people');
    title('\fontsize{14}SIR Model Stage3: Set Beta as a logistic function and Gamma as a constant');
    hold off

    function [x,fval] = paramfit(init,t,S,I)
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
    
        k_1 = parameters(1);
        L_1 = parameters(2);
        t_0_1 = parameters(3);
        Gamma_1 = parameters(4);
     
        t_int_1 = t;
        init_cond_1 = [S(1) I(1)];
        
        % Solve the ODE system
        [~,y_1] = ode15s(@(t,y) ode_sys(t, y, k_1, L_1, t_0_1, Gamma_1, N), t_int_1, init_cond_1); 
        
        % Calculate the sum of squares difference
        if length(S) == length(y_1(:,1))
            
            sse = sum((S - y_1(:,1)).^2) + sum((I - y_1(:,2)).^2);
            
        else
            
            sse = 10000000000;
            "error!?!" % this shouldn't happen
            
        end
    end

end


function dydt = ode_sys(t, y, k, L, t_0, Gamma, NN)

    % dS / dt = - beta * S * I / N;
    % dI / dt = beta * S * I / N - gamma * I;
    % Here, we set beta = L / (1 + exp( (k) * (t - t_0)))
    %
    % Inputs: 
    % y = [S I];
    
    dydt = [ - L / (1 + exp( (k) * (t - t_0))) * y(1) * y(2) / NN;
        L / (1 + exp( (k) * (t - t_0))) * y(1) * y(2) / NN - Gamma * y(2) ];
end
