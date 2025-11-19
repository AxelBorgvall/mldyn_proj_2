addpath('matlabfuncs')

function phi=uy2phi(z,nbacks)
    %regressor shape [N,na+nb+2]
    %z: [N,2] firs col output, second inp
    %phi = [-y(t-1), -y(t-2), ... , -y(t-na), u(t-nk), u(t-nk-1), ... , u(t-nk-nb+1)]
    na=nbacks(1);nb=nbacks(2);nk=nbacks(3);
    limiter=max(na,nk+nb-1);
    phi=zeros(size(z,1)-limiter,na+nb+1);

    for i = 1:(size(z,1)-limiter)
        t = limiter + i;
        y_idx = (t-1):-1:(t-na); 
        u_idx = (t-nk):-1:(t-nk-nb+1); 

        phi(i,1) = z(t,1);
        phi(i,2:1+na) = z(y_idx,1)';
        phi(i,1+na+1:end) = z(u_idx,2)';
    end
end


% given data
u=[1 2 3 4 5]';
y=[6 7 8 9 -1]';

% you can test the following calls. After the call the correct answer is
% given

uy2phi([y u],[1 1 0])
%      7     6     2
%      8     7     3
%      9     8     4
%     -1     9     5

uy2phi([y u],[1 1 1])
%      7     6     1
%      8     7     2
%      9     8     3
%     -1     9     4

uy2phi([y u],[1 1 2])
%      8     7     1
%      9     8     2
%     -1     9     3

uy2phi([y u],[1 2 2])
%      9     8     2     1
%     -1     9     3     2

uy2phi([y u],[3 2 2])
%      9     8     7     6     2     1
%     -1     9     8     7     3     2

% given data
u=[1 -1 2 -1 3 0 1]';
y=[2 -2 -3 -4 -2 0 1]';

% Your estimate should be
model=arxfit([y u],[2 1 2]);

model.theta

%     1.1573
%    -0.5004
%     0.2366

idpredict(model,[y u],1)

%          0
%     2.3146
%    -3.0789
%    -2.7077
%    -2.6550
%    -0.5496
%     1.7105

idpredict(model,[y u],3)

%          0
%          0
%     0.2366
%     0.8209
%    -1.2256
%    -0.2234
%     0.5249

ysim=idsim(model,u)

%          0
%          0
%     0.2366
%     0.0372
%     0.3978
%     0.2052
%     0.7481
% The following two calls give the figures displayed in the project
% instructions

idcompare(model,[y u],2)

idcompare(model,[y u],Inf)