function [A,B] = arxfit(varargin)
    % add  path temporarily
    oldpath = path;
    cleanup = onCleanup(@() path(oldpath));  % restore path when function exits
    addpath('proj1funcs');  

    if length(varargin) == 2
        [A,B]=arx1d(varargin{1},varargin{2});
    elseif length(varargin)==3
        [A,B]=arxnd(varargin{1},varargin{2},varargin{3});
    else
        error("incorrect number of args")
    end

    A=0;
    B=0;

end


function [A,B]= arx1d(z,nbacks)
    % z: [N,2] input/output
    % A: []
    A=0;
    B=0;

end

function [A,B]= arxnd(u,y,nbacks)
    A=0;
    B=0;
end
