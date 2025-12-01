function sys = id2tf(m)
    na = m.nn(1);  
    if m.type == "ARX"
        na = m.nn(1);
        a = m.theta(1:na);
        den = [1 -a']; % A(q)
    elseif m.type == "OE"
        nf = m.nn(1); % F(q) has 'na' coefficients in nn(1)
        f = m.theta(1:nf);
        den = [1 -f']; % F(q)
    else
        error("Unsupported model type for id2tf: " + m.type);
    end
    nb = m.nn(2);
    nk = m.nn(3);
    
    a = m.theta(1:na);          
    b = m.theta(na+1:end);      
    
    den = [1 -a'];    % denominator
    num = [zeros(1, nk) b'];    % numerator
    
    sys = tf(num, den, -1);
    b = m.theta(m.nn(1)+1:end);
    num = [zeros(1, nk) b']; % B(q)
    sys = tf(num, den, -1); % Use -1 for discrete time with unspecified sample time
end