function  m = crp(p,m)

    
    m.crp_z = zeros(height(m),1);
    for i  = p.crp_dates : height(m)
        t = zscore(cumprod(1+m.RTN_P(i-p.crp_dates+1:i-1)));           
        m.crp_z(i)  =  t(end);
    end
end