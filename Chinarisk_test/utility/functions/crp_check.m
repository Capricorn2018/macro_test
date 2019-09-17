function   [simulated_nav,allocation,weight] = crp_check(p,d,allocation_detail)
 
    [~,rtn_p_table ] = deal(array2table(p.model_trading_dates,'VariableNames',{'DATEN'}));
    
     load([d.data_path,'\','AU.mat'],'m');
     au = m; clear m; au.RTN_V = []; au.Properties.VariableNames = {'DATEN','AU'};
     
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
       o = strcmp(p.selected_comdty(i),p.ticker_list.name);   
       load([d.data_path,'\',cell2mat(p.ticker_list.name(o)),'.mat'],'m');
       m.RTN_V = [];
       z = crp(p,m);
       
       load([d.data_path,'\',cell2mat(p.ticker_list.index_vol(i)),'.mat'],'pe');
       pe = pe(:,{'DATEN',p.pe_type});
       pe.Properties.VariableNames(end) = {'PE'};
       m = erp(bond, pe,p);
       [~,ia,ib] = intersect(allocation_detail.DATEN,m.DATEN);
       m = m(ib,:);
       %idx_date = ismember(allocation_detail.DATEN,m.DATEN);
       idx_asset = strcmp(p.selected_eqt(i),allocation_detail.Properties.VariableNames(2:end));
       tmp = ones(size(m.erp_z));
       idx1 = m.erp_z<p.pe_lv1&m.erp_z>=p.pe_lv2;
       idx2 = m.erp_z<p.pe_lv2;
       tmp(idx1) =  p.pe_v_lv1;
       tmp(idx2) =  p.pe_v_lv2;
       s(ia,idx_asset) = tmp;
       clear pe;
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