function [nav,ret] = load_assets(filename,num_days,direction)
% 从Excel中读入指数历史水平，取每个月的某个交易日，并计算区间收益

     raw = readtable(filename);
     
    raw.Properties.VariableNames(1) = {'date'};
    raw.date = datenum(raw.date);

    reb = find_month_dates(num_days,raw.date,direction);

    [~,Locb] = ismember(reb,raw.date);

    nav = raw(Locb,:);
    ret = array2table(nan(size(nav)),'VariableNames',nav.Properties.VariableNames);
    ret.date = nav.date;

    for i = 1:length(reb)

        if(i>1)
            ret(i,2:end) = array2table(table2array(raw(Locb(i),2:end))./table2array(raw(Locb(i-1),2:end)) - 1);
        else
            ret(i,2:end)= array2table(nan(1,size(ret,2)-1));
        end
    end      

end

