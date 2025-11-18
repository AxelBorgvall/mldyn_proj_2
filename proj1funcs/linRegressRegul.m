function m = linRegressRegul(x, y, lambda)
    % Extend x and y to include regularization term
    p = size(x,2);
    x2 = [x; sqrt(lambda) * eye(p)];
    y2 = [y; zeros(p, size(y,2))];

    % Call standard least squares estimator
    m = LinRegress(x2, y2);
end