function m = LinRegress(x, y)
    % Check that x and y have the same number of rows (samples)
    if size(x,1) ~= size(y,1)
        error('x and y must have the same number of rows.');
    end

    % Least squares estimate of parameters (numerically stable)
    theta = x \ y;

    % Predicted outputs
    yhat = x * theta;

    % Number of samples and parameters
    n = size(x,1);
    p = size(x,2);

    % Compute variance (only if there is a single output variable)
    if size(y,2) == 1
        residuals = y - yhat;
        sigma2 = sum(residuals.^2) / (n - p);
        variance = sigma2 * inv(x' * x);
    else
        variance = [];
    end

    % Pack results in a struct
    m.model = 'LR';
    m.theta = theta;
    m.variance = variance;
end