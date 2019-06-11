
function result = load_factor(filename,reb,factor_name)
% 此处显示有关此函数的摘要
%   reb: rebalance_dates, 这里就是用load_assets里面的date就行
    
    raw = readtable(filename);
    raw.Properties.VariableNames = {'date',factor_name};
    raw.date = datenum(raw.date);
        
    [~,Locb] = ismember(reb,raw.date);
    
    result = raw(Locb,:);
    eval(['result.mean_',factor_name,' = zeros(height(result),1);'];
    
    for i = 1:length(reb)
        
        if(i>1)
            eval(['result.mean_',factor_name,'(i)= mean(raw.',factor_name,'((Locb(i-1)+1):Locb(i)));']);
        else
            eval(['result.mean_',factor_name,'(i) = mean(raw.',factor_name,'(1:Locb(i)));']);
        end
    end    

end

