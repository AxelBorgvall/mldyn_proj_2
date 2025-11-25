function idcompare(m,z,horizon)
    figure;     % activate or create figure

    [ypred, V_ypred] = idpredvar(m, z, horizon);
    x=1:size(z,1);
    % 95% confidence interval -> z-score approx 1.96
    conf = 1.96;
    upper_bound = ypred + conf * sqrt(V_ypred);
    lower_bound = ypred - conf * sqrt(V_ypred);

    plot(x, z(:,1),'DisplayName', 'true series');
    hold on;            % retain current plot so new plots add on

    plot(x, ypred,'DisplayName', 'predicted series');
    
    % Plot uncertainty area
    fill([x, fliplr(x)], [lower_bound', fliplr(upper_bound')], 'r', ...
         'FaceAlpha', 0.2, 'EdgeColor', 'none', 'DisplayName', '95% Confidence Interval');

    legend;

end