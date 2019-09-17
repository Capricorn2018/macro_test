function  [simulated_nav,weight]  = bulid_tg_index(p,input_table)
     
    % assume there are 2 assets  risky and nonrisky i.e. equity&comdity and bond
%     (x1,x2)[a,c](x1
%            [c,b] x2)  = a x1^2 +2c x1 x2  + b x2^2
     idx1  = p.reblance_dates>=input_table.DATEN(1);
     idx2  = p.reblance_dates<=input_table.DATEN(end);
     p.reblance_dates = p.reblance_dates(idx1&idx2);
   
     w = zeros(length( p.reblance_dates),2);
    for i  = 1 : length(p.reblance_dates)  
         if  p.reblance_dates(i) >= addtodate(input_table.DATEN(1), p.vol_dates, 'day')
                        
             id2 = find(p.reblance_dates(i)==input_table.DATEN,1,'first');
             id1 = find(addtodate(p.reblance_dates(i), -p.vol_dates, 'day')<=input_table.DATEN,1,'first');
             
             c  =  table2array(input_table(id1:id2,2:end));
   
             Sigma = 250*cov(c);
             vol = std(c,1)*sqrt(250);
             
             if any(vol==0),w(i,:) = 0; continue; end
             
             [m1,n1] = min(vol);
             [m2,n2] = max(vol);
             
             if m2< p.tgt_vol,  w(i,n2) = 1; continue; end;
             if m1> p.tgt_vol,  w(i,n1) = 1; continue; end;
             
             options = optimoptions('fsolve','OptimalityTolerance',1e-7);
             f = @(x)Sigma(1,1)* x*x + 2*Sigma(1,2)* x*(1-x)  + Sigma(2,2)* (1-x)*(1-x) - p.tgt_vol*p.tgt_vol;
             t =  fsolve(f,0.5,options)';
             if  t<0||t>1
                w(i,:) = 0; disp(['Õâ¸ösolver ÊÇÉµ±Æ£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡'])
             else
              %  t  = max(0.5,t);
                w(i,1) = t;
                w(i,2) = 1 - t;
             end

         else
               w(i,:) = 0; % if data for all asset is nan the invest on nothing
         end                     
    end
        weight_table = array2table([p.reblance_dates,w],'VariableNames',input_table.Properties.VariableNames);
        cost_table   = array2table([p.reblance_dates,zeros(size(w))],'VariableNames',input_table.Properties.VariableNames);
       [simulated_nav,weight] = simulator(input_table,weight_table,cost_table);
end

