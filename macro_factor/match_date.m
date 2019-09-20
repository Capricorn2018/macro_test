function [Lia,Locb] = match_date(date_mkt,date_macro)
% 宏观数据的日期都是每月1日，需要跟市场数据对应
% Lia: date_mkt里的日期是否对应date_macro里的某一个日期的年月
% Locb: date_mkt里的日期对应的date_macro里的日期的序号
    
    fd_mkt = datenum(year(date_mkt),month(date_mkt),1);
    fd_mcr = date_macro + 1; %wind取出来的宏观数据对应的日期好像都是每个月最后一天（注意不是工作日）
    
    [Lia,Locb] = ismember(fd_mkt,fd_mcr);

end

