function sys = id2tf(m)
    na = m.nn(1);  
    nb = m.nn(2);
    nk = m.nn(3);
    
    a = m.theta(1:na);          
    b = m.theta(na+1:end);      
    
    den = [1 -a'];    % denominator
    num = [zeros(1, nk) b'];    % numerator
    
    sys = tf(num, den, -1);
end