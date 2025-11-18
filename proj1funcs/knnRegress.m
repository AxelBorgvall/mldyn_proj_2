function m = knnRegress(x, y, k)
    % x: [N, d]
    % y: [N, d_out]
    % k: scalar (number of neighbors)
    if size(x,1) ~= size(y,1)
        error('knnRegress: x and y must have same number of rows.');
    end

    m = struct();
    m.model = 'KNN';
    m.x = x;
    m.y = y;
    m.k = k;
end