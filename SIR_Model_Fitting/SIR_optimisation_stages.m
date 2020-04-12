function SIR_optimisation_stages(y_experi)

% Apply SIR model and its variations to the handshake game: 
%
%       Stage 1: 
%               Treat Betta and Gamma as unknown parameters and solve for
%               them to minimise the residuals; 
%
%               However, at this stage, we can see from the output that
%               we need to make some changes to Gamma for a more accurate
%               fit. 
%
%
%       Stage 2: 
%               Set Gamma = A * exp(B * t), where A and B are unknowns.
%               Solve for Betta, A, and B to minimise the residuals;
%
%
%       Stage 3:
%               Set Betta = L / (1 + exp(k * (t - t_0))) and Gamma as
%               constant. Solve for L, k, t_0, and Gamma to minimise the
%               residuals. 
%
%
%       Stage 4:
%               Set Betta as a logistic function 
%               (Betta = L / (1 + exp( (k) * (t - t_0)))),
%               and Gamma as an exponential (Gamma = A * exp(B * t)).
%               Solve for L, k, t_0, A, and B to minimise the residuals.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%       Stage 1:
% [residual, Beta, Gamma] = parameters_optimisation_stage1(y_experi)
% Gamma_discrete(y_experi, @(t) Gamma);
% Beta_discrete(y_experi, @(t) Beta); 
% fprintf('**************************************************************************************\n');

%       Stage 2: 
% [residual, Beta, A, B] = parameters_optimisation_stage2(y_experi)
% Gamma_discrete(y_experi, @(t) A .* exp(B .* t));
% Beta_discrete(y_experi, @(t) Beta);
% fprintf('**************************************************************************************\n');

%       Stage 3: 
% [residual, k, L, t_0, Gamma] = parameters_optimisation_stage3(y_experi)
% Gamma_discrete(y_experi, @(t) Gamma);
% Beta_discrete(y_experi, @(t) L / (1 + exp(k * (t - t_0))));
% fprintf('**************************************************************************************\n');

%       Stage 4: 
[residual, k, L, t_0, A, B] = parameters_optimisation_stage4(y_experi)
title('\fontsize{14}SIR Model Stage4: Set Beta = L/(1+exp((k)*(t-t_0))), Gamma = Aexp(Bt)');
fprintf('**************************************************************************************\n');

% To see how our Beta, Gamma, and Delta obtained from the optimisation
% stage behaves: 
% Gamma_discrete(y_experi, @(t) A * exp(B * t));
% Beta_discrete(y_experi, @(t) L / (1 + exp(k * (t - t_0))));


end