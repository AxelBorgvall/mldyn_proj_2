% filepath: c:\Users\axelb\matlabProjects\mldyn_proj_2\arxfit_val.m
addpath('proj1funcs')
addpath('matlabfuncs')

% ...existing code...

rng(0);
N = 500;    

na=3;
nb=2;
nk=1;

nn=[na nb nk];
% many theta are unstable so i hardcoded this one. 
% when theta was random i got regressors with 10^94 sized elements!
theta = [0.5; -0.2; 0.1;  % a1, a2, a3
         0.4; -0.1];      % b1, b2
u = randn(N,1);

y = zeros(N,1);

for t = 1+max(na, nk+nb-1) : N
    %the contributions from a_k
    ypart = 0;
    for k = 1:na
        ypart = ypart + theta(k) * y(t-k);
    end

    % contributions from b_k
    upart = 0;
    u_indices = (t-nk):-1:(t-nk-nb+1);
    upart = theta(na+1:na+nb)' * u(u_indices);

    y(t) = ypart + upart;
end


z = [y, u];

% Fit
m = arxfit(z, nn);

disp("True theta:")
theta

disp("Estimated theta:")
est = m.theta;
est

% quick error metric
err = norm(est - theta);
fprintf("Estimation error (2-norm): %.4e\n", err);
