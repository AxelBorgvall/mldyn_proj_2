function sys = id2tf(m)
    na = m.nn(1);  % Or arx.nn(1) if following assignment exactly
    nb = m.nn(2);
    nk = m.nn(3);
    
    % Extract coefficients from theta
    a = m.theta(1:na);          % [a1; a2; ...; ana]
    b = m.theta(na+1:end);      % [b1; b2; ...; bnb]
    
    % Build denominator: [1 a1 a2 ... ana]
    den = [1 -a'];
    
    % Build numerator: [zeros(1, nk) b1 b2 ... bnb]
    num = [zeros(1, nk) b'];
    
    % Create transfer function (discrete, unspecified Ts = -1)
    sys = tf(num, den, -1);
end