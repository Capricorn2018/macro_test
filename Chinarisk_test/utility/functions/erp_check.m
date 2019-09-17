function   [simulated_nav,allocation_detail,stats] = erp_check(p,d,allocation_detail,s)
   
   rtn_p_table = array2table(p.model_trading_dates,'VariableNames',{'DATEN'});
    
   for i  = 1 : length(p.selected)
         load([d.data_path,'\',cell2mat(p.selected(i)),'.mat'],'m');
         m.RTN_V = [];
         rtn_p_table =  outerjoin(rtn_p_table,m,'Type','left','MergeKeys',true,'Keys','DATEN');  % p table to simulate returns
         clear m;
    end
   rtn_p_table.Properties.VariableNames(2:end)= p.selected;

   a = table2array(allocation_detail(:,2:end-1));

   idx = zeros(size(a,1),1);    idx(1) = 1;
    
   load([d.data_path,'\bond_yield.mat'],'bond');
   load([d.data_path,'\CASH.mat'],'m');   
   cash = m; clear m;
   cash.RTN_P = [];
   
   for i  = 1 : length(p.selected_eqt)
     % o = strcmp(p.selected_eqt(i),allocation_detail.Properties.VariableNames(2:end-1));
       o = strcmp(p.selected_eqt(i),p.ticker_list.name);
       load([d.data_path,'\',cell2mat(p.ticker_list.index_vol(o)),'.mat'],'pe');
       pe = pe(:,{'DATEN',p.pe_type});
       pe.Properties.VariableNames(end) = {'PE'};
       m = erp(bond, pe,p); 
       t = outerjoin(allocation_detail,m,'Type','left','MergeKeys',true,'Keys','DATEN');
       clear m
       
       idx_asset = strcmp(p.selected_eqt(i),allocation_detail.Properties.VariableNames(2:end));    
       idx_fi    = strcmp(p.selected_fi,    allocation_detail.Properties.VariableNames(2:end));    
       
       % 如果股票贵了，减仓股票 
       idx1 = (t.erp_z<p.pe_lv1)&(t.erp_z>=p.pe_lv2);
       c  =   a(idx1,idx_asset); % 这些日子该股票的权重存一下
       a(idx1,idx_asset) = a(idx1,idx_asset) -  p.pe_v_lv1*c;  %股票减仓
       a(idx1,idx_fi)    = a(idx1,idx_fi)    +  p.pe_v_lv1*c/sum(idx_fi); % 债券加仓  
       idx(idx1,1) = 1;
       clear c; clear idx1
       
       idx2 = t.erp_z<p.pe_lv2;
       c  =   a(idx2,idx_asset); % 这些日子该股票的权重存一下
       a(idx2,idx_asset) = a(idx2,idx_asset)  -  p.pe_v_lv2*c;  %股票减仓
       a(idx2,idx_fi)    = a(idx2,idx_fi)    +  p.pe_v_lv2*c/sum(idx_fi); % 债券加仓  
       idx(idx2,1) = 1;
       clear c; clear idx2
%        
%        % 如果债券贵了，加仓股票 
%        idx1 = t.erp_z>p.pe_lv1_&t.erp_z<=p.pe_lv2_;
%        c  =   a(idx1,idx_asset); % 这些日子该股票的权重存一下
%        a(idx1,idx_asset) = a(idx1,idx_asset) +  p.pe_v_lv1_*c;  %股票加仓
%        a(idx1,idx_fi)    = a(idx1,idx_fi)    -  p.pe_v_lv1_*c/sum(idx_fi); % 债券减仓  
%        idx(idx1,1) = 1;
%        clear c; clear idx1
%        
%        idx2 = t.erp_z>p.pe_lv2_;
%        c  =   a(idx2,idx_asset); % 这些日子该股票的权重存一下
%        a(idx2,idx_asset) = a(idx2,idx_asset)  +  p.pe_v_lv2_*c;  %股票减仓
%        a(idx2,idx_fi)    = a(idx2,idx_fi)    -  p.pe_v_lv2_*c/sum(idx_fi); % 债券加仓  
%        idx(idx2,1) = 1;
%        clear c; clear idx2       
       clear pe;
       t.Yield = [];
       t.PE = [];
       t.erp = [];
       t.erp_z = [];
   end
 
   t = outerjoin(allocation_detail,bond,'Type','left','MergeKeys',true,'Keys','DATEN');

   for  i = 251 : height(t)
       k = max(i-p.erp_dates+1,1);
       b = quantile(t.Yield(k:i-1),[0.5,0.75]);
       c = t.Yield(i-1);
       if  (c>=b(1))&&(c<b(2))
           a(i,:) =  a(i,:)*0.75;
           idx(i,1) = 1;
       end
       
       if c>=b(2)
          a(i,:) =  a(i,:)*0.5;
          idx(i,1) = 1;
       end
   end
   
   cash_position =  1  - sum(a,2);
   a = [a,cash_position];

   idxx = ismember(allocation_detail.DATEN,p.reblance_dates);
   idx(idxx,1) = 1;
   idx = find(idx);
   
    weight_table = array2table([allocation_detail.DATEN(idx),a(idx,:)],               'VariableNames',allocation_detail.Properties.VariableNames);
    cost_table   = array2table([allocation_detail.DATEN(idx),zeros(size(a(idx,:)))],  'VariableNames',allocation_detail.Properties.VariableNames);
    
       
   rtn_p_table = outerjoin(rtn_p_table,cash,'Type','left', 'MergeKeys',true,'Keys','DATEN') ;
   rtn_p_table.Properties.VariableNames(end) = {'MM'};
   weight_table.Properties.VariableNames(end) = {'MM'};
   cost_table.Properties.VariableNames(end) = {'MM'};
   [simulated_nav,weight] = simulator(rtn_p_table,weight_table,cost_table);
 %  [allocation] = from_detail_to_allocation_eqtbond(p,allocation_detail);
 
     simulated_nav = simulated_nav(simulated_nav.DATEN>=s,:);
    simulated_nav.NAV = simulated_nav.NAV./simulated_nav.NAV(1);
    allocation_detail  = weight(weight.DATEN>=s,:);

          
     ret_strategy =  power(simulated_nav.NAV(end)/simulated_nav.NAV(1),365/(simulated_nav.DATEN(end)-simulated_nav.DATEN(1)))-1;
     vol_strategy =  std(price2ret(simulated_nav.NAV,[],'Periodic'))*sqrt(250);
     maxDD_strategy = maxdrawdown(simulated_nav.NAV);
     stats = [p.tgt_vol,ret_strategy,vol_strategy,ret_strategy/vol_strategy,maxDD_strategy];
end