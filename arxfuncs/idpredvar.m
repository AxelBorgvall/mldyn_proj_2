function [ypred, V_ypred] = idpredvar(m, z, horizon)
    if m.type == "ARX"
        [ypred, V_ypred] = arxpredvar(m, z, horizon);
    elseif m.type == "OE"
        [ypred, V_ypred] = oepredvar(m, z);
    else
        error("unrecognized model type");
    end
end

function [ypred, V_ypred] = oepredvar(m, z)
    % For OE model, prediction is pure simulation.
    % y_hat(t) = G(q)u(t), where G(q) = B(q)/F(q)
    % The variance of the prediction comes from the uncertainty in theta.
    
    % First, get the simulated output
    ypred = idpredict(m, z, inf);

    % To get the variance, we need the gradient of y_hat w.r.t theta.
    % y_hat(t) = -f1*y_hat(t-1) - ... + b0*u(t-nk) + ...
    % Let phi_filtered(t) = [-y_hat(t-1), ..., u(t-nk), ...]
    % Then y_hat(t) = phi_filtered(t)' * theta
    % But this is recursive. An easier way is to filter.
    % d(y_hat)/d(bi) = (1/F(q)) * u(t-nk-i)
    % d(y_hat)/d(fi) = (-1/F(q)) * y_hat(t-i) = (-B(q)/F(q)^2) * u(t-i)
    
    nf = m.nn(1);
    nb = m.nn(2);
    nk = m.nn(3);
    theta = m.theta;
    P_theta = m.variance;
    u = z(:,2);
    N = size(z,1);

    f_poly = [1; -theta(1:nf)];

    psi = zeros(N, nf + nb);

    % Gradient w.r.t 'b' parameters
    for i = 1:nb
        u_delayed = [zeros(nk+i-1, 1); u(1:N-(nk+i-1))];
        psi(:, nf+i) = filter(1, f_poly, u_delayed);
    end

    % Gradient w.r.t 'f' parameters
    for i = 1:nf
        ypred_delayed = [zeros(i,1); ypred(1:N-i)];
        psi(:, i) = -filter(1, f_poly, ypred_delayed);
    end

    % Variance of prediction: V(y_hat) = psi * P_theta * psi'
    % We calculate this for each time step t
    V_ypred = zeros(N, 1);
    for t = 1:N
        psi_t = psi(t, :)';
        V_ypred(t) = psi_t' * P_theta * psi_t;
    end
end

function [ypred, V_ypred] = arxpredvar(m, z, horizon)
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

