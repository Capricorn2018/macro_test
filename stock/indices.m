function [ output_args ] = indices()
%INDEX 此处显示有关此函数的摘要
%   此处显示详细说明
    %[w_wsd_data_0,w_wsd_codes_0,w_wsd_fields_0,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('SPX.GI','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_1,w_wsd_codes_1,w_wsd_fields_1,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('HSI.HI','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_2,w_wsd_codes_2,w_wsd_fields_2,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000001.SH','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_3,w_wsd_codes_3,w_wsd_fields_3,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('399001.SZ','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_4,w_wsd_codes_4,w_wsd_fields_4,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000300.SH','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_5,w_wsd_codes_5,w_wsd_fields_5,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000905.SH','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_6,w_wsd_codes_6,w_wsd_fields_6,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000906.SH','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');
    %[w_wsd_data_7,w_wsd_codes_7,w_wsd_fields_7,w_wsd_times,w_wsd_errorid,w_wsd_reqid]=w.wsd('000852.SH','close,amt,pct_chg,turn,free_turn_n','2019-07-08','2019-08-06');

    [data,~,fields,times,~,~]=w.wsd('000300.SH','close,amt,pct_chg,turn,free_turn_n','2000-01-01','2019-08-06');
    
    tbl = array2table(data,'VariableNames',fields);
    tbl.times = times;
    
    tbl = tbl(:,['times';fields]);
    
    rvol20 = movstd(tbl.PCT_CHG,[19,0],'Endpoints','fill'); % 这是日期对应前20个工作日的波动率
    tbl.rvol20 = rvol20 * sqrt(252);
    
    rvol60 = movstd(tbl.PCT_CHG,[59,0],'Endpoints','fill');
    tbl.rvol60 = rvol60 * sqrt(252);
    
    rturn20 = movsum(tbl.FREE_TURN_N,[19,0],'Endpoints','fill');
    tbl.rturn20 = rturn20;
    
    rturn60 = movsum(tbl.FREE_TURN_N,[59,0],'Endpoints','fill');
    tbl.rturn60 = rturn60;
    
    reb = find_month_dates(5,tbl.times,'last');
    
    [~,Locb] = ismember(reb,tbl.times);
    tbl_mth = tbl(Locb,:);
    
    tbl_mth = tbl_mth(~isnan(tbl_mth.CLOSE),:);
    
    mth_rtn = tbl_mth.CLOSE(2:end)./tbl_mth.CLOSE(1:end-1) - 1;
    tbl_mth.mth_rtn = [mth_rtn;NaN];
    
end

