addpath('proj1funcs')
addpath('matlabfuncs')



na=3;
nb=2;
nk=1;

N=200

nn=[na nb nk];
theta=randn(na+nb,1);
u=randn(N,1);


% Preallocate output
y = zeros(N,1);

for t = 1+max(na, nk+nb-1) : N
    % y terms
    ypart = 0;
    for k = 1:na
        ypart = ypart + theta(k) * (y(t-k));
    end
    
    % u terms
    upart = 0;
    for k = 1:nb
        upart = upart + theta(na+k) * u(t - nk - (k-1));
    end
    
    y(t) = ypart + upart;
end

% z is the dataset your code expects
z = [y, u];

% Fit
m = arxfit(z, nn);

disp("True theta:")
theta

disp("Estimated theta:")
m.theta    % or however LinRegress stores it