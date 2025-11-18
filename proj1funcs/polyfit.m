function m = polyfit(x, y, lambda, n)
    N = size(x,1);
    d = size(x,2);
    % generate exponents
    if d == 1
        exponents = (0:n)';
    else
        exponents = generateExponents(d, n);
    end
    nTerms = size(exponents, 1);
    % build design matrix
    X_ext = ones(N, nTerms);
    for k = 1:nTerms
        X_ext(:,k) = prod(x .^ repmat(exponents(k,:), N, 1), 2);
    end
    % do regression
    m = linRegressRegul(X_ext, y, lambda);
    m.exponents = exponents;
end

function E = generateExponents(d, n)
    E = zeros(1, d); % include the zero-degree term

    % for each total degree add all ways to toss that degree balls into d buckets
    % uses stars and bars, diff takes the number of stars between bars
    for total = 1:n
        combos = nchoosek(1:(total + d - 1), d - 1); % each row length d-1
        C = [zeros(size(combos,1),1), combos, (total + d) * ones(size(combos,1),1)];
        M = diff(C,1,2) - 1; % size: nCombos x d
        E = [E; M];
    end
end