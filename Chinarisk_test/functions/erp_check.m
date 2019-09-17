function   [simulated_nav,allocation_detail,stats] = erp_check(p,d,allocation_detail,s)
   
   rtn_p_table = array2table(p.model_trading_dates,'VariableNames',{'DATEN'});
    
   for i  = 1 : length(p.selected)
         load([d.data_path,'\',cell2mat(p.selected(i)),'.mat'],'m');
         m.RTN_V = [];
         rtn_p_table =  outerjoin(rtn_p_table,m,'Type','left','MergeKeys',true,'Keys','DATEN');  % p table to simulate returns
         clear m;
    end
   rtn_p_table.Properties.VariableNames(2:end)= p.selected;

   
   load([d.data_path,'\CASH.mat'],'m');   
   cash = m; clear m;
   cash.RTN_P = [];
          
   rtn_p_table = outerjoin(rtn_p_table,cash,'Type','left', 'MergeKeys',true,'Keys','DATEN') ;
   rtn_p_table.Properties.VariableNames(end) = {'MM'};
%    for i  = 1 : length(p.selected_eqt)
%      % o = strcmp(p.selected_eqt(i),allocation_detail.Properties.VariableNames(2:end-1));
%        o = strcmp(p.selected_eqt(i),p.ticker_list.name);
%        load([d.data_path,'\',cell2mat(p.ticker_list.index_vol(o)),'.mat'],'pe');
%        pe = pe(:,{'DATEN',p.pe_type});
%        pe.Properties.VariableNames(end) = {'PE'};
%        m = erp(bond, pe,p); 
%        t = outerjoin(allocation_detail,m,'Type','left','MergeKeys',true,'Keys','DATEN');
%        clear m
%        
%        idx_asset = strcmp(p.selected_eqt(i),allocation_detail.Properties.VariableNames(2:end));    
%        idx_fi    = strcmp(p.selected_fi,    allocation_detail.Properties.VariableNames(2:end));    
%        
%        % 如果股票贵了，减仓股票 
%        idx1 = (t.erp_z<p.pe_lv1)&(t.erp_z>=p.pe_lv2);
%        c  =   a(idx1,idx_asset); % 这些日子该股票的权重存一下
%        a(idx1,idx_asset) = a(idx1,idx_asset) -  p.pe_v_lv1*c;  %股票减仓
%        a(idx1,idx_fi)    = a(idx1,idx_fi)    +  p.pe_v_lv1*c/sum(idx_fi); % 债券加仓  
%        idx(idx1,1) = 1;
%        clear c; clear idx1
%        
%        idx2 = t.erp_z<p.pe_lv2;
%        c  =   a(idx2,idx_asset); % 这些日子该股票的权重存一下
%        a(idx2,idx_asset) = a(idx2,idx_asset)  -  p.pe_v_lv2*c;  %股票减仓
%        a(idx2,idx_fi)    = a(idx2,idx_fi)    +  p.pe_v_lv2*c/sum(idx_fi); % 债券加仓  
%        idx(idx2,1) = 1;
%        clear c; clear idx2
% %        
% %        % 如果债券贵了，加仓股票 
% %        idx1 = t.erp_z>p.pe_lv1_&t.erp_z<=p.pe_lv2_;
% %        c  =   a(idx1,idx_asset); % 这些日子该股票的权重存一下
% %        a(idx1,idx_asset) = a(idx1,idx_asset) +  p.pe_v_lv1_*c;  %股票加仓
% %        a(idx1,idx_fi)    = a(idx1,idx_fi)    -  p.pe_v_lv1_*c/sum(idx_fi); % 债券减仓  
% %        idx(idx1,1) = 1;
% %        clear c; clear idx1
% %        
% %        idx2 = t.erp_z>p.pe_lv2_;
% %        c  =   a(idx2,idx_asset); % 这些日子该股票的权重存一下
% %        a(idx2,idx_asset) = a(idx2,idx_asset)  +  p.pe_v_lv2_*c;  %股票减仓
% %        a(idx2,idx_fi)    = a(idx2,idx_fi)    -  p.pe_v_lv2_*c/sum(idx_fi); % 债券加仓  
% %        idx(idx2,1) = 1;
% %        clear c; clear idx2       
%        clear pe;
%        t.Yield = [];
%        t.PE = [];
%        t.erp = [];
%        t.erp_z = [];
%    end
%  
 

  %%  macro  
    
%    pmi = load_edb('M0017126');
%    ppi = load_edb('M0000612'); 
%    cpi = load_edb('M0001227');
    load(['D:\Projects\Chinarisk\data\input\macro\cpi.mat'],'cpi');
    load(['D:\Projects\Chinarisk\data\input\macro\ppi.mat'],'ppi');
    load(['D:\Projects\Chinarisk\data\input\macro\pmi.mat'],'pmi');
    
    
   inflation = m_table( cpi,ppi );
   inflation.VALUE   = 0.5*(inflation.VALUE_eom_a_+inflation.VALUE_eom_b_)/2;
   inflation.VALUE_eom_a_ = [];
   inflation.VALUE_eom_b_ = [];
   
 
    
    [ date20 ] = get_date_in_month( allocation_detail.DATEN, 20 );
    date20 = [allocation_detail.DATEN(1);date20];
    
    a = zeros(length(date20),size(allocation_detail,2));
    a(:,1) = date20;
    
    [idx,loc] = ismember(allocation_detail.DATEN,date20);
    
    a = table2array(allocation_detail(idx,:));
    macros = NaN(size(a,1),2);
    for i = 2 : size(a,1)
        idx_pmi = find(pmi.DATEN<=a(i,1),1,'last');
        if ~isempty(idx_pmi)&&idx_pmi>11
           if mean(pmi.VALUE(idx_pmi-2:idx_pmi))>=mean(pmi.VALUE(idx_pmi-11:idx_pmi))
              macros(i,1) = 1;
           else
              macros(i,1) = -1; 
           end
        end
         
        idx_inflation = find(inflation.DATEN<=a(i,1),1,'last');
        if ~isempty(idx_inflation)&&idx_inflation>11
           if mean(inflation.VALUE(idx_inflation-2:idx_inflation))>=mean(inflation.VALUE(idx_inflation-11:idx_inflation))
              macros(i,2) = 1;
           else
              macros(i,2) = -1; 
           end
        end
        
        idx_csi100  = strcmp(allocation_detail.Properties.VariableNames,'CSI100');
        idx_csi500  = strcmp(allocation_detail.Properties.VariableNames,'CSI500');
        idx_cs1     = strcmp(allocation_detail.Properties.VariableNames,'CS1');
        idx_cu      = strcmp(allocation_detail.Properties.VariableNames,'CU');
        idx_au      = strcmp(allocation_detail.Properties.VariableNames,'AU');
        idx_m       = strcmp(allocation_detail.Properties.VariableNames,'M');
 
        
        if  ~isnan(macros(i,1))&&~isnan(macros(i,2))
            if  (macros(i,1)==1)&&(macros(i,2)==1)   % 超配铜
           %     cu_tmp = a(i,idx_cu) ;
            %    a(i,idx_cu)  = min(1,2*cu_tmp);
                
           %     up = a(i,idx_cu) - cu_tmp;
                
               % k = a(i,idx_csi100) + a(i,idx_csi500) + a(i,idx_cs1) + a(i,idx_au) + a(i,idx_m);
           %     k = a(i,idx_cs1);
                
             %   a(i,idx_csi100) = a(i,idx_csi100) - up*a(i,idx_csi100)/k;
             %   a(i,idx_csi500) = a(i,idx_csi500) - up*a(i,idx_csi500)/k;
            %    a(i,idx_cs1)    = max(a(i,idx_cs1)    - up*a(i,idx_cs1)/k,0);
               a(i,idx_cs1) = 0*a(i,idx_cs1);
            %   a(i,idx_csi100) = 0*a(i,idx_csi100) ;
             %  a(i,idx_csi500) =  0*a(i,idx_csi500) ;
             %   a(i,idx_au)     = a(i,idx_au)     - up*a(i,idx_au)/k;
             %   a(i,idx_m)      = a(i,idx_m)      - up*a(i,idx_m)/k;
            end   
            
            if  (macros(i,1)==-1)&&(macros(i,2)==-1)   % 超配债券
               %  bond_tmp = a(i,idx_cs1) ;
               %  a(i,idx_cs1)  = min(1,2*bond_tmp);
                
               %  up = a(i,idx_cs1) - bond_tmp;
                
               %  k = a(i,idx_csi100) + a(i,idx_csi500) + a(i,idx_cu) + a(i,idx_au) + a(i,idx_m);
               %  k = a(i,idx_cu) ;
                
               %     a(i,idx_csi100) = a(i,idx_csi100) - up*a(i,idx_csi100)/k;
                 %    a(i,idx_csi100) = 0.5*a(i,idx_csi100) ;
                 %   a(i,idx_csi500) = 0.5*a(i,idx_csi500) ;
               %     a(i,idx_csi500) = a(i,idx_csi500) - up*a(i,idx_csi500)/k;
               %      a(i,idx_cu)    = max(a(i,idx_cu)    - up*a(i,idx_cu)/k,0);
              %       a(i,idx_cu) =  0*a(i,idx_cu);
               %      a(i,idx_au)     = a(i,idx_au)     - up*a(i,idx_au)/k;
               %       a(i,idx_au)   = 0*a(i,idx_au) ;
               %      a(i,idx_m)      = a(i,idx_m)      - up*a(i,idx_m)/k;
               %       a(i,idx_m)   = 0.5*a(i,idx_m) ;
             
            end   
                       
            if  (macros(i,1)==-1)&&(macros(i,2)==1)   % 减磅股票             
%                 a(i,idx_csi100) = 0.5*a(i,idx_csi100);
%                 a(i,idx_csi500) = 0.5*a(i,idx_csi500);      
                  a(i,idx_cu)    = 0*a(i,idx_cu);
            end   
            
            if  (macros(i,1)==1)&&(macros(i,2)==-1)   % 增配股票
%                 eqt_tmp = a(i,idx_csi100) + a(i,idx_csi500);
%                 tmp_max = min(1,2*eqt_tmp);
%                 a(i,idx_csi100) = tmp_max*a(i,idx_csi100)/eqt_tmp;
%                 a(i,idx_csi500) = tmp_max*a(i,idx_csi500)/eqt_tmp;
% 
%                 
%                 up = tmp_max - eqt_tmp;
%                 
%                 k = a(i,idx_cs1) + a(i,idx_cu) + a(i,idx_au) + a(i,idx_m);
%                 
%                 a(i,idx_cs1) = a(i,idx_cs1) - up*a(i,idx_cs1)/k;
%                 a(i,idx_cu)    = a(i,idx_cu)    - up*a(i,idx_cu)/k;
%                 a(i,idx_au)     = a(i,idx_au)     - up*a(i,idx_au)/k;
%                 a(i,idx_m)      = a(i,idx_m)      - up*a(i,idx_m)/k;
              %  a(i,idx_cs1)   = 0.5*a(i,idx_cs1);
              %  a(i,idx_cu)    = 0.5*a(i,idx_cu)  ;
                 a(i,idx_au)     = 0*a(i,idx_au) ;
              %  a(i,idx_m)      = 0.5*a(i,idx_m) ;

            end   
%             
        end
        
    end
    
    a(:,8) =  1  - sum(a(:,2:7),2);
    
    
     
    weight_table = array2table(a,               'VariableNames',allocation_detail.Properties.VariableNames);
    cost_table   = array2table([a(:,1),zeros(size(a,1),size(a,2)-1)],  'VariableNames',allocation_detail.Properties.VariableNames);
    
       
   %rtn_p_table = outerjoin(rtn_p_table,cash,'Type','left', 'MergeKeys',true,'Keys','DATEN') ;
   %rtn_p_table.Properties.VariableNames(end) = {'MM'};
   weight_table.Properties.VariableNames(end) = {'MM'};
   cost_table.Properties.VariableNames(end) = {'MM'};
   [simulated_nav,weight] = simulator(rtn_p_table,weight_table,cost_table);

 
    simulated_nav = simulated_nav(simulated_nav.DATEN>=s,:);
    simulated_nav.NAV = simulated_nav.NAV./simulated_nav.NAV(1);
    allocation_detail  = weight(weight.DATEN>=s,:);
%     
    %%
  load([d.data_path,'\bond_yield.mat'],'bond');
  t = outerjoin(allocation_detail,bond,'Type','left','MergeKeys',true,'Keys','DATEN');
  a = table2array(allocation_detail(:,2:end-1));
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
   
      a(:,7) =  1  - sum(a(:,1:6),2);
%    cash_position =  1  - sum(a,2);
%    a = [a,cash_position];

   idxx = ismember(allocation_detail.DATEN,p.reblance_dates);
   idx(idxx,1) = 1;
   idx = find(idx);
   
    weight_table = array2table([allocation_detail.DATEN(idx),a(idx,:)],               'VariableNames',allocation_detail.Properties.VariableNames(1:end-1));
    cost_table   = array2table([allocation_detail.DATEN(idx),zeros(size(a(idx,:)))],  'VariableNames',allocation_detail.Properties.VariableNames(1:end-1));
    

   weight_table.Properties.VariableNames(end) = {'MM'};
   cost_table.Properties.VariableNames(end) = {'MM'};
   [simulated_nav,weight] = simulator(rtn_p_table,weight_table,cost_table);
 %  [allocation] = from_detail_to_allocation_eqtbond(p,allocation_detail);
 
    simulated_nav = simulated_nav(simulated_nav.DATEN>=s,:);
    simulated_nav.NAV = simulated_nav.NAV./simulated_nav.NAV(1);
    allocation_detail  = weight(weight.DATEN>=s,:);    
     %%     
     ret_strategy =  power(simulated_nav.NAV(end)/simulated_nav.NAV(1),365/(simulated_nav.DATEN(end)-simulated_nav.DATEN(1)))-1;
     vol_strategy =  std(price2ret(simulated_nav.NAV,[],'Periodic'))*sqrt(250);
     maxDD_strategy = maxdrawdown(simulated_nav.NAV);
     stats = [p.tgt_vol,ret_strategy,vol_strategy,ret_strategy/vol_strategy,maxDD_strategy];
end