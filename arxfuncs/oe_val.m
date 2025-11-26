
% filepath: c:\Users\axelb\matlabProjects\mldyn_proj_2\arxfit_val.m
addpath('proj1funcs')
addpath('matlabfuncs')

% ...existing code...

rng(0);
N = 10000;    
vari=0;
varo=0;

na=3;
nb=2;
nk=1;

nn=[na nb nk];
% many theta are unstable so i hardcoded this one. 
% when theta was random i got regressors with 10^94 sized elements!
theta = [0.7; -0.5; 0.4;  % a1, a2, a3
         0.6; 0.6];      % b1, b2
if vari~=0
    u = sin((1:N)/(1))'+sin((1:N)/0.5)'+sin((1:N)/(0.33))'+sin((1:N)/(5))'+randn(N,1)*vari;
else
    u = sin((1:N)/(1))'+sin((1:N)/0.5)'+sin((1:N)/(0.33))'+sin((1:N)/(5))';
end
size(u)
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

noise=randn(N,1)*varo;
if varo~=0
    y=y+noise;
end

z = [y, u];

% Fit
m = oefit(z, nn);

disp("True theta:")
theta

disp("Estimated theta:")
est = m.theta;
est

% quick error metric
err = norm(est - theta);
fprintf("Estimation error (2-norm): %.4e\n", err);
