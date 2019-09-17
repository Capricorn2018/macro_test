  function m = erp(bond, pe,p)

        m = fill_data(bond,pe,3);
        m.erp = 1./m.PE - m.Yield/100;
        m.erp_z = zeros(height(m),1);

        for i  = 251 : height(m)
            k = max(i-p.erp_dates+1,1);
            x = zscore(m.erp(k:i-1)); 
            m.erp_z(i)  =  x(end);
        end
  end