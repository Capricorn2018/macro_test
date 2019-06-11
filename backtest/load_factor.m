function result = load_factor(filename,num_days,direction)
% 从Excel中读入某个因子数据，取某个月的固定交易日，并计算区间均值
    
    raw = readtable(filename);
    raw.Properties.VariableNames = {'date','factor'};
    raw.date = datenum(raw.date);
    
    reb = find_month_dates(num_days,raw.date,direction);
    
    [~,Locb] = ismember(reb,raw.date);
    
    result = raw(Locb,:);
    result.mean = zeros(height(result),1);
    
    for i = 1:length(reb)
        
        if(i>1)
            result.mean(i) = mean(raw.factor((Locb(i-1)+1):Locb(i)));
        else
            result.mean(i) = mean(raw.factor(1:Locb(i)));
        end
    end    

end

