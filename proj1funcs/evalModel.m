function yhat = evalModel(m, x)
    % handle knn models
    if isfield(m, 'model') && strcmp(m.model, 'KNN')
        k = m.k;
        Nq = size(x,1);
        Ntrain = size(m.x,1);
        k = min(k, Ntrain);
        % compute squared distances
        D = bsxfun(@plus, sum(x.^2,2), sum(m.x.^2,2)') - 2*(x * m.x');
        % Sort each row to find nearest neighbors
        [~, idx] = sort(D, 2, 'ascend');
        idx = idx(:, 1:k); % Nq x k
        % average neighbors' outputs
        d_out = size(m.y, 2);
        yhat = zeros(Nq, d_out);
        for i = 1:Nq
            neighIdx = idx(i, :);
            yhat(i, :) = mean(m.y(neighIdx, :), 1);
        end
        return;
    end

    % handle polynomial models
    if isfield(m, 'exponents')
        N = size(x,1);
        nTerms = size(m.exponents,1);
        X_ext = ones(N, nTerms);
        for i = 1:nTerms
            X_ext(:,i) = prod(x .^ repmat(m.exponents(i,:), N, 1), 2);
        end
        yhat = X_ext * m.theta;
        return;
    end
    % if theta is 2D: simple linear model
    if ndims(m.theta) == 2
        yhat = x * m.theta;
        return;
    end
end
