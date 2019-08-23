
function result = load_factor(filename,reb)
% 此处显示有关此函数的摘要
%   reb: rebalance_dates, 这里就是用load_assets里面的date就行
    
%     raw = readtable(filename);
%     raw.Properties.VariableNames = {'date',factor_name};
%     raw.date = datenum(raw.date);
    x = load(filename);
    raw = x.factors;
        
    [~,Locb] = ismember(reb,raw.date);
    
    Locb = Locb(Locb>0);    
    
    result = raw(Locb,:);
    
    for k = 2:size(raw,2)
        factor_name = raw.Properties.VariableNames{k};
        eval(['result.mean_',factor_name,' = nan(height(result),1);']);
        
        eval(['result.vol_',factor_name,'_1 = nan(height(result),1);']);
        eval(['result.vol_',factor_name,'_3 = nan(height(result),1);']);
        eval(['result.vol_',factor_name,'_6 = nan(height(result),1);']);

        for i = 1:length(Locb)

            if(i>1)
                eval(['result.mean_',factor_name,'(i)= mean(raw.',factor_name,'((Locb(i-1)+1):Locb(i)));']);
                eval(['result.vol_',factor_name,'_1(i)= std(raw.',factor_name,'((Locb(i-1)+1):Locb(i)));']);
            else
                eval(['result.mean_',factor_name,'(i) = mean(raw.',factor_name,'(1:Locb(i)));']);
                eval(['result.vol_',factor_name,'_1(i)= std(raw.',factor_name,'(1:Locb(i)));']);
            end
            
            if(i>3)
                eval(['result.vol_',factor_name,'_3(i)= std(raw.',factor_name,'((Locb(i-3)+1):Locb(i)));']);
            else
                eval(['result.vol_',factor_name,'_3(i)= std(raw.',factor_name,'(3:Locb(i)));']);
            end
            
            if(i>6)
                eval(['result.vol_',factor_name,'_6(i)= std(raw.',factor_name,'((Locb(i-6)+1):Locb(i)));']);
            else
                eval(['result.vol_',factor_name,'_6(i)= std(raw.',factor_name,'(6:Locb(i)));']);
            end
            
        end    
    end

end

