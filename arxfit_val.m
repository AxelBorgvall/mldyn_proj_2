% filepath: c:\Users\axelb\matlabProjects\mldyn_proj_2\arxfit_val.m
addpath('proj1funcs')
addpath('matlabfuncs')

% ...existing code...

% Set seed for reproducibility and larger sample for stability
rng(0);
N = 500;    % was 200

na=3;
nb=2;
nk=1;

nn=[na nb nk];
% Use a known, stable theta instead of a random one to prevent blow-up
% theta = randn(na+nb,1);
theta = [0.5; -0.2; 0.1;  % a1, a2, a3
         0.4; -0.1];      % b1, b2
u = randn(N,1);

% Preallocate output
y = zeros(N,1);

for t = 1+max(na, nk+nb-1) : N
    % y terms (same ordering as arxfit: first na entries -> y(t-k) coefficients)
    ypart = 0;
    for k = 1:na
        ypart = ypart + theta(k) * y(t-k);
    end

    % u terms (then nb entries)
    upart = 0;
    % The regressor vector is [y(t-1)...y(t-na) u(t-nk)...u(t-nk-nb+1)]
    % So theta is [a1..an b1..bn] where b1 corresponds to u(t-nk)
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
