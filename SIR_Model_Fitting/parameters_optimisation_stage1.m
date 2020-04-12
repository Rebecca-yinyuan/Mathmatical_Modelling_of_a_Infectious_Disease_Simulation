function [fval,beta,gamma] = parameters_optimisation_stage1(data)

% Optimisation Stage 1: 
%   Treat Beta and Gamma as unknown parameters and solve for
%   them to minimise the residual.
%   The output fval is the residual we obtained. 


    S = data(:,1);
    I = data(:,2);
    R = data(:,3);
    N = S(1) + I(1) + R(1);
    t = 0:length(S)-1;

    % Initial guess for [beta, gamma]:
    initial_guess = [rand; rand];

    % Fitting parameters
    [x, fval] = paramfit(initial_guess,t,S,I);
    beta = x(1);
    gamma = x(2);

    % Comparing solution to data
    % Initial conditions
    init_cond = [S(1) I(1)];
    [~,y] = ode45(@(t,y) ode_sys(t,y,beta,gamma,N), t, init_cond);
    
    plot(t,I,'r.','MarkerSize',17);
    hold on
    plot(t,S,'g.','MarkerSize',17);
    plot(t,R,'b.','MarkerSize',17);
    plot(t,y(:,1),'g-', 'LineWidth', 2);
    plot(t,y(:,2),'r-', 'LineWidth', 2);
    plot(t,ones(length(S),1)*N - y(:,2) - y(:,1),'b-', 'LineWidth', 2);
    axis([0 length(I) 0 N]);
    xlabel('\fontsize{14}Time');
    ylabel('\fontsize{12}# Susceptible(green), Infected(red), Recovered(blue) people');
    title('\fontsize{14}SIR Model Stage1: Set Beta and Gamma as unknown constants');
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
    
        beta_1 = parameters(1);
        gamma_1 = parameters(2);
     
        t_int_1 = t;
        init_cond_1 = [S(1) I(1)];
        
        % Solve the ODE system
        [~,y_1] = ode45(@(t,y) ode_sys(t,y,beta_1,gamma_1,N), t_int_1, init_cond_1); 
        
        % Calculate the sum of squares difference
        if length(S) == length(y_1(:,1))
            
            sse = sum((S - y_1(:,1)).^2) + sum((I - y_1(:,2)).^2);
            
        else
            
            sse = 100000000;
            "error!?!" % this shouldn't happen
            
        end
    end

end


function dydt = ode_sys(t,y,beta,gamma,NN)

    % dS / dt = beta * S * I / N;
    % dI / dt = beta * S * I / N - gamma * I;
    %
    % Inputs: 
    % y = [S I];

    dydt = [ -beta * y(1) * y(2) / NN;
        beta * y(1) * y(2) / NN - gamma * y(2) ];
end
