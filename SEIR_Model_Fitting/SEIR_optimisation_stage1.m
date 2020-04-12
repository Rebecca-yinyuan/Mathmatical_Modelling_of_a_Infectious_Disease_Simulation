function [residual, Beta, Gamma, Delta] = SEIR_optimisation_stage1(data)

% This function treats Beta, Gamma, and Delta as unknown constants and
% solve for them to minimise the residuals.


    S = data(:,1);
    E = data(:,2);
    I = data(:,3);
    R = data(:,4);
    N = S(1) + E(1) + I(1) + R(1);
    t = 0:length(S)-1;

    % Initial guess for parameters [Beta_ini, Gamma_ini, Delta_ini]
    initial_guess = [1 + 0.01 * rand; 
        rand; 
        1 + 0.01 * rand];

    % Fitting parameters
    [x, residual] = paramfit(initial_guess,t,S,E,I);
    Beta = x(1);
    Gamma = x(2);
    Delta = x(3);

    % Comparing solution to data
    % Initial conditions
    init_cond = [S(1) E(1) I(1)];
    [~,y] = ode45(@(t,y) ode_sys(t,y,Beta,Gamma,Delta, N), t, init_cond);

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
    title('\fontsize{14}SEIR Model Stage1: Set Beta, Gamma and Delta as unknown constants');
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
    
        beta_1 = parameters(1);
        gamma_1 = parameters(2);
        delta_1 = parameters(3);
     
        t_int_1 = t;
        init_cond_1 = [S(1) E(1) I(1)];
        
        % Solve the ODE system
        [~,y_1] = ode45(@(t,y) ode_sys(t,y,beta_1,gamma_1,delta_1,N), t_int_1, init_cond_1); 
        
        % Calculate the sum of squares difference
        if length(S) == length(y_1(:,1))
            
            sse = sum((S - y_1(:,1)).^2) + sum((E - y_1(:,2)).^2) + sum((I - y_1(:,3)).^2);
            
        else
            
            sse = 100000000;
            "error!?!" % this shouldn't happen
            
        end
    end

    function dydt = ode_sys(t,y,beta,gamma,delta,NN)

    % dS / dt = - beta * S * I / N;
    % dE / dt = beta * S * I / N - delta * E;
    % dI / dt = delta * E - gamma * I;
    %
    % Inputs: 
    % y = [S E I];

    dydt = [ - beta * y(1) * y(3) / NN;
        beta * y(1) * y(3) / NN - delta * y(2);
        delta * y(2) - gamma * y(3)];
    end

end