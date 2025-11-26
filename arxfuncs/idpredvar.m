function [ypred, V_ypred] = idpredvar(m, z, horizon)
    na = m.nn(1); % outputs considered
    nb = m.nn(2); % inputs considered
    nk = m.nn(3); % delay

    theta = m.theta(:);
    y = z(:,1);
    u = z(:,2);
    N = size(z,1);

    P_theta = m.variance;

    ypred = zeros(N,1);
    V_ypred = zeros(N,1);

    % for every value in input sequence
    % horizon is the recursive steps ahead
    for t = 1:N
        % Determine the cutoff point for using measured y.
        cutoff = max(t - horizon, 0);
        
        % sets to length required by params or all historical if greater
        ylen = max([t, na, nb + nk - 1, 1]);

        ytemp = zeros(ylen, 1);
        V_ytemp = zeros(ylen, 1);
        if cutoff >= 1
            ytemp(1:cutoff) = y(1:cutoff); % measured outputs where allowed
        end

        % from t-horizon to t, recursively predict states 
        for k = cutoff + 1 : t
            % build regressor vector phi_k
            idx_y = k - (1:na);
            reg_y = zeros(na, 1);
            valid_y = idx_y >= 1;
            reg_y(valid_y) = ytemp(idx_y(valid_y));

            idx_u = k - nk - (0:nb-1);
            reg_u = zeros(nb, 1);
            valid_u = idx_u >= 1 & idx_u <= N;
            reg_u(valid_u) = u(idx_u(valid_u));
            
            phi_k = [reg_y; reg_u];

            % predict
            ytemp(k) = phi_k' * theta;

            % propagate variance
            % from parameter uncertainty
            V_param = phi_k' * P_theta * phi_k;
            
            % from past prediction noise propagation
            V_reg_y = zeros(na,1);
            V_reg_y(valid_y) = V_ytemp(idx_y(valid_y));
            V_prop = theta(1:na)' * V_reg_y;

            % total variance for ytemp
            V_ytemp(k) = V_param+ V_prop;
        end
        
        ypred(t) = ytemp(t);
        V_ypred(t) = V_ytemp(t);
    end
end

