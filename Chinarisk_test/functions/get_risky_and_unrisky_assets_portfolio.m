function [nav_eqt,weight_eqt,w_eqt,...
          nav_fi,weight_fi,w_fi,...
          nav_comdty,weight_comdty,w_comdty,...
          nav,weight,w] = get_risky_and_unrisky_assets_portfolio(d,p)

    % build equity and commodty rp portfolio accordingly  and then build rp portfolio between equity and commodty
   
    % repare v table and p table
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
       
    % rp portfolio for comdty
    tickers_comdty = cellstr(intersect([p.ticker_list.name(strcmp(p.ticker_list.asset_class ,'comdty_s'))', ...
                                           p.ticker_list.name(strcmp(p.ticker_list.asset_class ,'comdty_c'))'], p.selected));
   
    [~,loc] = ismember(tickers_comdty,tickers);
    tickers_comdty = tickers(loc);  
    [nav_comdty,weight_comdty,w_comdty]  = bulid_rp_index(p, tickers_comdty, p.selected_comdty_w, rtn_v_table, rtn_p_table);                                    
                                       
      
    tickers_risky = {'EQT','COMDTY'};
    u = [nav_eqt.NAV,nav_comdty.NAV];
    rtn_table = array2table([nav_eqt.DATEN,[zeros(1,2);price2ret(u,[],'Periodic')]],'VariableNames',{'DATEN','EQT','COMDTY'});


    [nav,weight,w]  = bulid_rp_index(p, tickers_risky,  p.selected_w([1,3]), rtn_table, rtn_table);  
end