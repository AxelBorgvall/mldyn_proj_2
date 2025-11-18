function plotModel(m, x, y)
    xg = linspace(min(x), max(x), 300)';
    yg = evalModel(m, xg); % expects Nx1 input

    figure;
    hold on;
    scatter(x, y, 36, 'b', 'filled');

    plot(xg, yg, '-r', 'LineWidth', 2);
    xlabel('x');
    ylabel('y');
    title('Data and fitted model (1D)');
    legends = {};
    legends{end+1} = 'data';
    legends{end+1} = 'model';
    legend(legends, 'Location', 'best');
    grid on;
    hold off;
end