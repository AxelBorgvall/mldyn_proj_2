% filepath: c:\Users\axelb\matlabProjects\mldyn_proj_1\linRegFuncs\plot3d.m
function plot3d(m, x, y)
    % 3D plot of 2D data and fitted model
    % m: model struct
    % x: Nx2 input data
    % y: Nx1 output data
    
    if size(x,2) ~= 2
        error('plot3d assumes 2D input x (Nx2).');
    end
    
    if nargin < 3 || isempty(y)
        y = [];
    end
    
    if ~isempty(y) && size(y,2) > 1
        y = y(:,1);  % use first output column
    end
    
    figure;
    hold on;
    
    % Scatter plot of data
    if ~isempty(y)
        scatter3(x(:,1), x(:,2), y, 36, 'b', 'filled');
    end
    
    % Try to create surface plot from model
    try
        % Create 2D grid over data range
        x1_range = linspace(min(x(:,1)), max(x(:,1)), 40);
        x2_range = linspace(min(x(:,2)), max(x(:,2)), 40);
        [X1, X2] = meshgrid(x1_range, x2_range);
        
        % Flatten to Nx2 for evalModel
        x_grid = [X1(:), X2(:)];
        y_grid = evalModel(m, x_grid);
        
        if size(y_grid,2) > 1
            y_grid = y_grid(:,1);
        end
        
        % Reshape back to grid
        Z = reshape(y_grid, size(X1));
        
        % Plot surface
        surf(X1, X2, Z, 'FaceAlpha', 0.7, 'EdgeColor', 'none');
        colormap('cool');
        
    catch ME
        disp("fuck...")
    end
    
    xlabel('x_1');
    ylabel('x_2');
    zlabel('y');
    title('3D model fit and data');
    if ~isempty(y)
        legend('data', 'model', 'Location', 'best');
    else
        legend('model', 'Location', 'best');
    end
    grid on;
    hold off;
end