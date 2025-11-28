function ypred = idpredict(m, z, horizon)
    if m.type=="ARX"
        ypred=arxpred(m,z,horizon);
    elseif m.type=="OE"
        ypred=oepred(m,z,horizon);
    else
        error("unrecognized model type");
    end
end

function ypred=oepred(m,z,horizon)
    ypred=arxpred(m,z,inf);
end


function ypred = arxpred(m, z, horizon)
    na = m.nn(1); %outputs considered
    nb = m.nn(2); %inputs considered
    nk = m.nn(3); %delay

    theta = m.theta(:);
    y = z(:,1);
    u = z(:,2);
    N = size(z,1);

    ypred = zeros(N,1);

    % for every value in input sequence
    % horizon is the recursive steps ahead
    for t = 1:N
        % Determine the cutoff point for using measured y.
        % For horizon greater than t we sim from start
        cutoff=max(t-horizon,0);
        
        %sets to length required by params or all historical if greater
        ylen=max([t,na,nb+nk-1,1]);

        ytemp = zeros(ylen,1);
        if cutoff >= 1
            % ytemp 1:t-horizon is filled since 
            ytemp(1:cutoff) = y(1:cutoff);   % measured outputs where allowed
        end

        % from t-horizon to t, recursively predict states 
        for k = cutoff+1 : t
            idx_y = k - (1:na);
            reg_y = zeros(na,1);
            valid = idx_y >= 1;
            reg_y(valid) = ytemp(idx_y(valid));   % use measured or simulated y

            % build input regressors u(k-nk), u(k-nk-1), ..., u(k-nk-nb+1)
            idx_u = k - nk - (0:nb-1);
            reg_u = zeros(nb,1);
            valid_u = idx_u >= 1 & idx_u <= N;    % ensure u index in range
            reg_u(valid_u) = u(idx_u(valid_u));

            % combine and predict
            ytemp(k) = [reg_y; reg_u]' * theta;
        end
        
        ypred(t) = ytemp(t);
    end
end
