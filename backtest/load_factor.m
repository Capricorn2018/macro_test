function result = load_factor(filename,reb)
% �˴���ʾ�йش˺�����ժҪ
%   reb: rebalance_dates, ���������load_assets�����date����
    
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

