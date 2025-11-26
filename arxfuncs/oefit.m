function m=oefit(z,nn)
    temp_model=arxfit(z,[nn(1)*4,nn(2)*4,nn(3)]);
    
    ys = idsim(temp_model, z(:,2));
    
    ah = temp_model.theta(1:nn(1)*4);
    
    % create the filter 1/A(q) using the estimated params
    filter_den = [1; -ah];
    
    % filter the simulated output and the original input
    zf = filter(1, filter_den, [ys, z(:,2)]);
    
    % fit an ARX model on the filtered data to get the OE parameters
    m = arxfit(zf, nn);
    m.type = "OE"; % set the model type to output-error
end

% simple version-------------------------------------------------------------------------------------
% function m=oefit(z,nn)
%     temp_model=arxfit(z,[nn(1)*4,nn(2)*4,nn(3)]);
%     %do sim
%     ys=idsim(temp_model,z(:,1));

%     m=arxfit([ys z(:,2)],nn);

% end
