function ysim = idsim(model, u)
    sys = id2tf(model);        
    ysim = lsim(sys, u);
end