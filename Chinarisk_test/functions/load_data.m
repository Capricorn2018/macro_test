function load_data(d,p)
    
   w = windmatlab' ;w.menu;
%%  prices  
    for i  = 1 : height(p.ticker_list)

           % load data to calculate vol
           [s,~,~,t] = w.wsd(p.ticker_list.index_vol(i),'close',p.dates.start_date_data ,p.dates.end_date_data );
           vol_index   = array2table([t(2:end),price2ret(s,[],'Periodic')],'VariableNames',{'DATEN','RTN_V'});
           vol_index(isnan(vol_index.RTN_V),:) = [];
           clear s t
           
           % load data to mark the cumrtn
           if strcmp( p.ticker_list.asset_class(i),'comdty_s')
              [s,~,~,t] = w.wsd(p.ticker_list.index_rtn(i),'settle',p.dates.start_date_data ,p.dates.end_date_data);
           else
              [s,~,~,t] = w.wsd(p.ticker_list.index_rtn(i),'close',p.dates.start_date_data ,p.dates.end_date_data);
           end
           price_index = array2table([t(2:end),price2ret(s,[],'Periodic')],'VariableNames',{'DATEN','RTN_P'});
           price_index(isnan(price_index.RTN_P),:) = [];
           clear s t
           
           if vol_index.DATEN(1)>price_index.DATEN(1)
              idx = find(vol_index.DATEN(1)<= price_index.DATEN,1,'first');
              if idx>1
                 vol_index = array2table([table2array(price_index(1:idx-1,:));table2array(vol_index)],'VariableNames',{'DATEN','RTN_V'});
              end
           else
              idx = find(price_index.DATEN(1)<= vol_index.DATEN,1,'first');
              if idx>1
                 price_index = array2table([table2array(vol_index(1:idx-1,:));table2array(price_index)],'VariableNames',{'DATEN','RTN_P'});
              end
           end
     
           m   =  outerjoin(vol_index,price_index,'Type','left','MergeKeys',true,'Keys','DATEN');
           
%            z = isnan(table2array(m(:,2:end)));
%            sum(z(:))
                 
           save([d.data_path,'\',cell2mat(p.ticker_list.name(i)),'.mat'],'m');
           clear m
               
    end
%%  trading dates
%        [~,~,~,model_trading_dates,~,~]   = w.tdays(p.dates.start_date_test,p.dates.end_date_test) ;   
%        [~,~,~,all_trading_dates,  ~,~]   = w.tdays(p.dates.start_date_data,p.dates.end_date_data) ;   
%        save([d.data_path,'\model_trading_dates.mat'],'model_trading_dates','all_trading_dates');
%%  bond yield    
%        [w_edb_data,~,~,w_edb_times,~,~] = w.edb( p.bond_ticker,p.dates.start_date_data,p.dates.end_date_data,'Fill=Previous');
%        bond = array2table([w_edb_times,w_edb_data],'VariableNames',{'DATEN','Yield'});
%        save([d.data_path,'\bond_yield.mat'],'bond');
%%  equity pe
 %      xx = p.ticker_list(strcmp(p.ticker_list.asset_class,'eqt'),:);
%        for i  = 1 : size(xx,1)
%           idx = strcmp(p.selected_eqt(i),p.ticker_list.name);
%           [w_wsd_data1,~,~,w_wsd_times1,~,~] = w.wsd(p.ticker_list.index_vol(idx),p.pe_type,p.dates.start_date_data,p.dates.end_date_data,'Fill=Previous');
%           pe  = array2table([w_wsd_times1,w_wsd_data1],'VariableNames',{'DATEN','PE'});
%           save([d.data_path,'\',cell2mat(xx.index_vol(i)),'.mat'],'pe');
%        end

%         conn   = database('WINDDB', 'js_dev',  '123456'   );
%         xx = p.ticker_list(strcmp(p.ticker_list.asset_class,'eqt'),:);
%         for i  = 1 : size(xx,1)
%             q = ['SELECT t1.s_info_windcode, t1.Trade_Dt,T1.PE_TTM,t2.est_pe FROM wind.Aindexvaluation t1 INNER JOIN wind.aindexconsensusrollingdata t2',...
%                  ' ON t1.s_info_windcode = t2.s_info_windcode AND t2.rolling_type=''FY1''' ,' AND t1.trade_dt = t2.est_dt',...
%                  ' WHERE t1.s_info_windcode = ''' cell2mat(xx.index_vol(i)) '''',...
%                  ' ORDER BY t1.trade_dt '];
%             t = q_table( conn,q);
%             daten = zeros(height(t),1);
%                for j = 1 : length(daten)
%                    x = cell2mat(t.TRADE_DT(j));
%                    daten(j,1) = datenum(str2double(x(1:4)),str2double(x(5:6)),str2double(x(7:8)));
%                end
%               pe   = array2table([daten,t.PE_TTM,t.EST_PE],'VariableNames',{'DATEN','PE_TTM','EST_PE'});
%               save([d.data_path,'\',cell2mat(p.ticker_list.index_vol(i)),'.mat'],'pe');
%         end
end