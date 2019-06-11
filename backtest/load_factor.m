<<<<<<< HEAD
function result = load_factor(filename,num_days,direction)
% 从Excel中读入某个因子数据，取某个月的固定交易日，并计算区间均值
=======
function result = load_factor(filename,reb)
% 此处显示有关此函数的摘要
%   reb: rebalance_dates, 这里就是用load_assets里面的date就行
>>>>>>> 2ca188e63853e3af8ee3f593559f68626a0f6c5c
    
    raw = readtable(filename);
    raw.Properties.VariableNames = {'date','factor'};
    raw.date = datenum(raw.date);
        
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

