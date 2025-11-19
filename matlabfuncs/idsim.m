function ysim = idsimulate(model, z)
    sys = id2tf(model);        
    u   = z(:,2);
    ysim = lsim(sys, u);
end