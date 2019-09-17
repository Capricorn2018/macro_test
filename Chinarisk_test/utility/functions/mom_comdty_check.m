function   [simulated_nav,allocation,weight] = mom_comdty_check(p,d,allocation_detail)
    [~,rtn_p_table ] = deal(array2table(p.model_trading_dates,'VariableNames',{'DATEN'}));
    
   for i  = 1 : length(p.selected)
         load([d.data_path,'\',cell2mat(p.selected(i)),'.mat'],'m');
         m.RTN_V = [];
         rtn_p_table =  outerjoin(rtn_p_table,m,'Type','left','MergeKeys',true,'Keys','DATEN');  % p table to simulate returns
         clear m;
    end
    [~,rtn_p_table.Properties.VariableNames(2:end)] = deal(p.selected);

    a = table2array(allocation_detail(:,2:end-1));
    s = ones(size(a));
   
   for i  = 1 : length(p.selected_comdty)
       o = strcmp(p.selected_comdty(i),allocation_detail.Properties.VariableNames(2:end-1));
       load([d.data_path,'\',cell2mat(p.ticker_list.name(o)),'.mat'],'m');
       m.RTN_V = [];
       m.RTN_S = ones(height(m),1);
       
       t_date_index =  find(m.DATEN >addtodate(m.DATEN(1),6,'month'),1,'first');
       for j = t_date_index: height(m)          
           id1 =  find(m.DATEN >=addtodate(m.DATEN(j),-6,'month'),1,'first');
           id2 =  j-1;
           t = cumprod(1 + m.RTN_P(id1:id2));
           if t(end)<1
              id = m.DATEN(j)==allocation_detail.DATEN;
              s(id,o) =0;
           end
       end
%        
%        [y,loc]  = ismember(allocation_detail.DATEN,m.DATEN);
%        s(y,o')  =  m.RTN_S(loc(loc>0));
%        
       clear m;
   end
 
   a = a.*s;
   idx = zeros(size(a,1),1);
   idx(1) = 1;
   for i  = 2 : size(a,1)
       if any(s(i,:)~=s(i-1,:)) %
          idx(i,1) = 1;
       end
   end
   idxx = ismember(allocation_detail.DATEN,p.reblance_dates);
   idx(idxx,1) = 1;
   idx = find(idx);
   
    weight_table = array2table([allocation_detail.DATEN(idx),a(idx,:)],               'VariableNames',allocation_detail.Properties.VariableNames(1:end-1));
    cost_table   = array2table([allocation_detail.DATEN(idx),zeros(size(a(idx,:)))],  'VariableNames',allocation_detail.Properties.VariableNames(1:end-1));
    

   [simulated_nav,weight] = simulator(rtn_p_table,weight_table,cost_table);
    [allocation] = from_detail_to_allocation(p,allocation_detail);
end