function ypred = idpredict(m, z, horizon)
    na = m.nn(1);
    nb = m.nn(2);
    nk = m.nn(3);

    theta = m.theta(:);
    y = z(:,1);
    u = z(:,2);

    N = size(z,1);
    ypred = zeros(N,1);

    for t = 1:N

        % output regressors: -y(t-1), -y(t-2), ..., -y(t-na)
        idx_y = t - (1:na);
        reg_y = zeros(na,1);
        valid = idx_y >= 1; % only include indices > 0
        reg_y(valid) = y(idx_y(valid));   

        % input regressors: u(t-nk), u(t-nk-1), ..., u(t-nk-nb+1)
        idx_u = t - nk - (0:nb-1);
        reg_u = zeros(nb,1);
        valid = idx_u >= 1;
        reg_u(valid) = u(idx_u(valid));

        % Prediction y(t) = theta' * phi
        ypred(t) = [reg_y; reg_u]' * theta;
    end
end