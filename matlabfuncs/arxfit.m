function m = arxfit(varargin)
    if length(varargin) == 2
        m=arx1d(varargin{1},varargin{2});
    elseif length(varargin)==3
        m=arxnd(varargin{1},varargin{2},varargin{3});
    else
        error("incorrect number of args")
    end
end

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


function m= arx1d(z,nbacks)
    % z: [N,2] input/output
    phi=uy2phi(z,nbacks);
    m=LinRegress(phi(:,2:end), phi(:,1));
    m.type="ARX";
    m.nn=nbacks;
end

function [A,B]= arxnd(u,y,nbacks)
    % Maybe I will implement this if i get bored, maybe not :)
    A=0;
    B=0;
end
