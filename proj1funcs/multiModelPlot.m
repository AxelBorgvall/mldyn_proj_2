% filepath: c:\Users\axelb\matlabProjects\mldyn_proj_1\linRegFuncs\multiModelPlot.m
function multiModelPlot(models, x, y)
    % models: cell array of model structs (or a single model struct)
    % x: Nx1 input (1D)
    % y: optional Nx1 (or NxD) data to scatter
    %
    % Example:
    % multiModelPlot({m1,m2}, x, y)

    if ~iscell(models)
        models = {models};
    end

    if nargin < 2
        error('multiModelPlot: requires at least models and x.');
    end

    if size(x,2) ~= 1
        error('multiModelPlot assumes 1D input x (Nx1).');
    end

    if nargin < 3
        y = [];
    end

    % Sort inputs for plotting
    [xs, idx] = sort(x);
    if ~isempty(y)
        ys = y(idx,:);
    end

    % Fine grid for smooth curves
    xg = linspace(min(xs), max(xs), 400)';

    % Prepare figure
    figure;
    hold on;

    % Plot data if provided
    if ~isempty(y)
        scatter(xs, ys(:,1), 20, [0.2 0.2 0.9], 'filled'); % first output only
    end

    % Colors/line styles
    colors = lines(max(1,numel(models)));
    styles = {'-','--',':','-.'};

    legendEntries = {};
    if ~isempty(y)
        legendEntries{end+1} = 'data';
    end

    % Plot each model
    for i = 1:numel(models)
        m = models{i};
        try
            yg = evalModel(m, xg);
        catch ME
            warning('multiModelPlot: evalModel failed for model %d: %s', i, ME.message);
            continue;
        end

        if size(yg,2) > 1
            yg = yg(:,1); % plot first output only
        end

        col = colors(mod(i-1,size(colors,1))+1, :);
        sty = styles{mod(i-1,numel(styles))+1};
        plot(xg, yg, 'Color', col, 'LineStyle', sty, 'LineWidth', 2);

        % Legend label: prefer m.model, fallback to Model i
        if isfield(m, 'model') && ischar(m.model)
            lbl = sprintf('%s', m.model);
        else
            lbl = sprintf('Model %d', i);
        end
        % If multiple models share same label append index
        lbl = sprintf('%s_%d', lbl, i);

        legendEntries{end+1} = lbl;
    end

    xlabel('x');
    ylabel('y');
    title('Data and multiple model fits (1D)');
    legend(legendEntries, 'Location', 'best');
    grid on;
    hold off;
end