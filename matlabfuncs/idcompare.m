function idcompare(m,z,horizon)
    figure;     % Activate or create figure

    ypred=idpredict(m,z,horizon);

    x=1:size(z,1);

    plot(x, z(:,1),'DisplayName', 'true series');
    hold on;            % Retain current plot so new plots add on

    plot(x, ypred,'DisplayName', 'predicted series');

    legend;

end