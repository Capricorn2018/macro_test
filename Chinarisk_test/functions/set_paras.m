function  p = set_paras(d,p)
    p.dates.start_date_data = '2002-01-01';
    p.dates.end_date_data   = '2019-08-30';
    
    p.dates.start_date_test = '2002-01-01';
    p.dates.end_date_test   =  '2019-08-30';
    
    p.selected_eqt = {'CSI300','CSI500'};
    p.selected_eqt_w = ones(1,length(p.selected_eqt))/length(p.selected_eqt);
   
   % p.selected_fi  = {'CS2','IR'};
    p.selected_fi  = {'CS1','IR1'};
    p.selected_fi_w  = ones(1,length(p.selected_fi))/length(p.selected_fi);
    
    p.selected_comdty = {'CU','AU'};
    p.selected_comdty_w  = ones(1,length(p.selected_comdty))/length(p.selected_comdty);
    
    p.selected   = [ p.selected_eqt,p.selected_fi,p.selected_comdty ];
    p.selected_w = [49/100,49/100,2/100];
    
    p.corr_dates = 365; % days to cal cov matrix in rp and tg
    p.vol_dates  = 365; % days to cal vol in bp 
    
    p.bond_ticker = 'M1000166'; % 10年国债   
    p.bond_ticker = 'M1004271'; % 10年国开 
    
    p.erp_dates = round(365*2);
    p.pe_type = 'PE_TTM';
    % 股 --> 债
    p.pe_lv1 = -1.5;
    p.pe_v_lv1 = 0.5; % 股票减磅,如果全部减掉，这里是1，如果都不剪，这里是0
    p.pe_lv2 = -2;
    p.pe_v_lv2 = 0.5;

    p.load = 1;
    
    if p.load
         w = windmatlab' ;w.menu;
         [~,~,~,model_trading_dates,~,~]   = w.tdays(p.dates.start_date_test,p.dates.end_date_test) ;   
         [~,~,~,all_trading_dates,  ~,~]   = w.tdays(p.dates.start_date_data,p.dates.end_date_data) ;   
         save([d.data_path,'\model_trading_dates.mat'],'model_trading_dates','all_trading_dates');
    else
         load([d.data_path,'\model_trading_dates.mat'],'model_trading_dates','all_trading_dates');
    end
    
    p.model_trading_dates = model_trading_dates;
    p.all_trading_dates = all_trading_dates;
    p.reblance_dates =  get_date_in_month( model_trading_dates, 31 );
    
  
    p.growth_var = 0.5;
    p.ir = 0;
    p.shibor = 0.5;
    
end