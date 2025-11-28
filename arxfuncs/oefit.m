function m=oefit(z,nn)
    nn_high = [nn(1)*4, nn(2)*4, nn(3)];
    temp_model = arxfit(z, nn_high);
    % simulate model to get ys
    ys = idpredict(temp_model, z, inf);
    % make the oe model
    m = arxfit([ys, z(:,2)], nn);
    m.type = "OE"; 
end


% simple version-------------------------------------------------------------------------------------
% function m=oefit(z,nn)
%     nn_high = [nn(1)*4, nn(2)*4, nn(3)];
%     temp_model = arxfit(z, nn_high);
%     % simulate model to get ys
%     ys = idpredict(temp_model, z, inf);
%     % make the oe model
%     m = arxfit([ys, z(:,2)], nn);
%     m.type = "OE"; 
% end
