function ypred = idpredict(m, z, horizon)
    na = m.nn(1);
    nb = m.nn(2);
    nk = m.nn(3);

    theta = m.theta(:);
    y = z(:,1);
    u = z(:,2);
    N = size(z,1);

    ypred = zeros(N,1);

    % for every value in input sequence
    % horizon is the recursive steps ahead
    for t = 1:N

        if t < horizon % if t<"horizon" we output 0 and ignore (bcuz no historical data?)
            ypred(t) = 0;
            continue
        end

        %from every t cutoff is horizon steps back
        cutoff = t - horizon; % last index where measured y is allowed
        ytemp = zeros(t,1);
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


%{
function ypred = vecotrized(m, z, horizon)
    na = m.nn(1);
    nb = m.nn(2);
    nk = m.nn(3);

    theta = m.theta(:);
    y = z(:,1);
    u = z(:,2);
    N = size(z,1);

    ypred = zeros(N,1);

    if horizon > 1
        ypred(1:horizon-1) = 0;
    end

    % step 2: for each t >= horizon, build the entire temporary y-path at once
    for t = horizon:N
        cutoff = t - horizon;

        % temp y track: measured data up to cutoff,
        % then predictions for the remaining part
        ytemp = zeros(t,1);
        if cutoff >= 1
            ytemp(1:cutoff) = y(1:cutoff);
        end

        % number of simulation steps needed
        sim_len = t - cutoff;

        % Create matrices of indices for regressors
        % -------
        % Y regressors: y(k-1), ..., y(k-na)
        yy = cutoff+(1:sim_len)';                   % k from cutoff+1 .. t
        Yidx = yy - (1:na);                         % sim_len x na

        validY = (Yidx >= 1);                       % boolean mask
        regY = zeros(sim_len, na);
        regY(validY) = ytemp(Yidx(validY));

        % U regressors: u(k-nk), u(k-nk-1), ..., u(k-nk-nb+1)
        Uidx = yy - nk - (0:nb-1);                  % sim_len x nb
        validU = (Uidx >= 1 & Uidx <= N);
        regU = zeros(sim_len, nb);
        regU(validU) = u(Uidx(validU));

        % Combine
        Phi = [regY, regU];

        % Simulate forward in one matrix multiplication
        ysim = Phi * theta;

        % Fill ytemp for the simulated portion
        ytemp(cutoff+1:t) = ysim;

        % Final output
        ypred(t) = ytemp(t);
    end
end

%}



