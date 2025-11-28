function m=oefit(z,nn)
    % estimate high order arx
    multiplier = 4;
    nn_high = [nn(1) * multiplier, nn(2) * multiplier, nn(3)];
    temp_model = arxfit(z, nn_high);

    % simulate output
    ys = idpredict(temp_model, z, inf);
    ah_coeffs = [1, -temp_model.theta(1:nn_high(1))'];
    zf = filter(ah_coeffs, 1, [ys, z(:,2)]);
    m = arxfit(zf, nn);

    m.type = "OE";
end

% simple ------------------------------

% function m=oefit(z,nn)
%     % estimate high order arx
%     multiplier = 4;
%     nn_high = [nn(1) * multiplier, nn(2) * multiplier, nn(3)];
%     temp_model = arxfit(z, nn_high);

%     % simulate output
%     ys = idpredict(temp_model, z, inf);
% m = arxfit([ys, z(:,2)], nn);
    
%     m.type = "OE";
% end
