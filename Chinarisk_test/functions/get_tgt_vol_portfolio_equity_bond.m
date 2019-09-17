function [simulated_nav,allocation,allocation_detail, stats] =  get_tgt_vol_portfolio_equity_bond(d,p,s)

%    [nav_eqt,   weight_eqt,   w_eqt,...
%     nav_fi,    weight_fi,    w_fi,...
%     nav_comdty,weight_comdty,w_comdty,... 
%     nav,       weight_risky, w            ] = get_risky_and_unrisky_assets_portfolio(d,p);
     
    p.selected   = [ p.selected_eqt,p.selected_fi];

    [rtn_v_table,rtn_p_table ] = deal(array2table(p.model_trading_dates,'VariableNames',{'DATEN'}));
    for i  = 1 : length(p.selected)
         load([d.data_path,'\',cell2mat(p.selected(i)),'.mat'],'m');
         m.RTN_P = [];
         rtn_v_table =  outerjoin(rtn_v_table,m,'Type','left','MergeKeys',true,'Keys','DATEN');  % v table to calculate correlation and volatility
         clear m;

         load([d.data_path,'\',cell2mat(p.selected(i)),'.mat'],'m');
         m.RTN_V = [];
         rtn_p_table =  outerjoin(rtn_p_table,m,'Type','left','MergeKeys',true,'Keys','DATEN');  % p table to simulate returns
         clear m;
    end
    [rtn_v_table.Properties.VariableNames(2:end),rtn_p_table.Properties.VariableNames(2:end)] = deal(p.selected);

    tickers = rtn_v_table.Properties.VariableNames(2:end);
    
    % rp portfolio for eqt
    tickers_eqt = cellstr(intersect(p.selected,p.ticker_list.name(strcmp(p.ticker_list.asset_class ,'eqt'))'));
    [~,loc] = ismember(tickers_eqt,tickers);
    tickers_eqt = tickers(loc);    
    [nav_eqt,weight_eqt,w_eqt]  = bulid_rp_index(p, tickers_eqt, p.selected_eqt_w, rtn_v_table, rtn_p_table);
    
    % rp portflop for fi
    tickers_fi = cellstr(intersect(p.ticker_list.name(strcmp(p.ticker_list.asset_class ,'fi'))', p.selected));
    [~,loc] = ismember(tickers_fi,tickers);
    tickers_fi = tickers(loc);  
    [nav_fi,weight_fi,w_fi]  = bulid_rp_index(p, tickers_fi, p.selected_fi_w, rtn_v_table, rtn_p_table); 
  
    u = [nav_fi.NAV,nav_eqt.NAV];
    
    input_table = array2table([nav_fi.DATEN,[zeros(1,2);price2ret(u,[],'Periodic')]],'VariableNames',{'DATEN','FI','EQT'});
    [simulated_nav,weight]  = bulid_tg_index(p,input_table);
   
    wtable = zeros(height(simulated_nav),size(weight_eqt,2)-1);

    eqt_w     = weight.EQT;
  %  comdty_w  = weight.RISKY.*weight_risky.COMDTY;
    fi_w      = weight.FI;
    
    allocation = array2table([simulated_nav.DATEN,eqt_w,fi_w,1-eqt_w-fi_w],'VariableNames',{'DATEN','EQT','FI','CASH'});
    
    [~,id_eqt]    = ismember(p.selected_eqt,   p.selected);
    [~,id_fi]     = ismember(p.selected_fi,    p.selected);
%    [~,id_comdty] = ismember(p.selected_comdty,p.selected);
    
    x = table2array(weight_eqt(:,2:end));
    wtable(:,id_eqt) = repmat(eqt_w,1,length(id_eqt)).* x(:,id_eqt); clear x;
    
    x = table2array(weight_fi(:,2:end));
    wtable(:,id_fi) = repmat(fi_w,1,length(id_fi)).* x(:,id_fi); clear x;
%     
%    x = table2array(weight_comdty(:,2:end));
%     wtable(:,id_comdty) = repmat(comdty_w,1,length(id_comdty)).* x(:,id_comdty); clear x;
%     
    wtable(:,end) = 1 - sum(wtable(:,1:end-1),2);
    
    allocation_detail = array2table([simulated_nav.DATEN,wtable],'VariableNames',weight_eqt.Properties.VariableNames);
    
      simulated_nav = simulated_nav(simulated_nav.DATEN>=s,:);
    simulated_nav.NAV = simulated_nav.NAV./simulated_nav.NAV(1);
    allocation  = allocation(allocation.DATEN>=s,:);
    allocation_detail  = allocation_detail(allocation_detail.DATEN>=s,:);
          
     ret_strategy =  power(simulated_nav.NAV(end)/simulated_nav.NAV(1),365/(simulated_nav.DATEN(end)-simulated_nav.DATEN(1)))-1;
     vol_strategy =  std(price2ret(simulated_nav.NAV,[],'Periodic'))*sqrt(250);
     maxDD_strategy = maxdrawdown(simulated_nav.NAV);
     stats = [p.tgt_vol,ret_strategy,vol_strategy,ret_strategy/vol_strategy,maxDD_strategy];
end