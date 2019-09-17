function [simulated_nav,weight,w] = bulid_rp_index_w(reblance_dates,corr_dates,tickers,w_,rtn_v_table, rtn_p_table)
   
    [idx,~] = ismember(rtn_v_table.Properties.VariableNames(2:end),tickers);
    
    if  sum(idx)~=length(tickers)
        error('tickers should be part of v_table')
    end
    
    if length(w_)~=length(tickers)
       error('length of risk weight should be equal to length of assets')
    end
        
    [w, trans_cost] = deal(zeros(length(reblance_dates),size(rtn_v_table,2)-1));
    
    % update w 
    for i  = 1 : length(reblance_dates)  
        %disp(i)
         if  reblance_dates(i) >= addtodate(rtn_v_table.DATEN(1), corr_dates, 'day')
                        
             id2 = find(reblance_dates(i)==rtn_v_table.DATEN,1,'first');
             id1 = find(addtodate(reblance_dates(i), -corr_dates, 'day')<=rtn_v_table.DATEN,1,'first');
             
             c  =  table2array(rtn_v_table(id1:id2,2:end));
             non_nan_asset   = ~any(isnan(c),1)&idx; % id1 到 id2区间内，资产价格不能有NAN ，同时应该是前面约束的那些资产
             c = c(:,non_nan_asset);
            if isempty(c)
                 w(i,:) = 0; 
                 continue;
            end
             
             
            if  sum(non_nan_asset)==1
                w(i,non_nan_asset) = 1;  % if there is only 1 asset, then all invest on it
            else
                Sigma = 205*cov(c);
                x0_ = (1./std(c,1)*sqrt(250))'; x0 = x0_/sum(x0_);
                if any(isnan(x0)) % 如果c中有两种资产，有一种为现金，那就没法做rp 了，那就啥都不投资了。 但如果c中只有一个资产，且非现金，那么就投资这一个。
                    w(i,:) = 0;
                    continue;
                end
                w0  = zeros(1,size(rtn_v_table,2)-1);
                w0(idx)  =  w_;
                w0(~non_nan_asset) = 0;                
                w0  =  w0/sum(w0); w0 = w0';
                z = size(Sigma,1);
                Aineq = [];
                bineq = [];
                Aeq = ones(1,z);        % fully invested
                beq = 1;               
                lb = zeros(z,1);       
                ub = ones(z,1);      
                [w(i,non_nan_asset),fval,exitflag,output,solutions] = risk_parity(Sigma,w0,x0,Aineq,bineq,Aeq,beq,lb,ub);
            end
         else
               w(i,:) = 0; % if data for all asset is nan the invest on nothing
         end                     
    end

    weight_table = array2table([reblance_dates,w],         'VariableNames',rtn_v_table.Properties.VariableNames);
    cost_table   = array2table([reblance_dates,trans_cost],'VariableNames',rtn_v_table.Properties.VariableNames);
    
   w   = array2table([reblance_dates,w],'VariableNames',rtn_v_table.Properties.VariableNames);
   [simulated_nav,weight] = simulator(rtn_p_table,weight_table,cost_table);
end