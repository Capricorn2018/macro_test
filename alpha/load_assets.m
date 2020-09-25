function [nav,ret] = load_assets(filename,filename_value,reb)

    %raw = readtable(filename);
    x = load(filename);
    raw = x.assets;
     
    %raw.Properties.VariableNames(1) = {'date'};
    %raw.date = datenum(raw.date);

    %reb = find_month_dates(num_days,raw.date,direction);

    [d,v] = load_value(filename_value);
    [~,Lia,Locb] = intersect(d,raw.date);
    raw.value = nan(height(raw),1);
    raw.value(Locb) = v(Lia);
    if d(end)<raw.date(end)
        disp('Error in load_assets.m: value file is not updated');
    end
    raw.value = fillmissing(raw.value,'previous');
    %raw.value(isnan(raw.value)) = 1;
    
    [~,Locb] = ismember(reb,raw.date);
    
    Locb = Locb(Locb>0); % 去掉不在raw.date里面的
    nav = raw(Locb,:);
    
    ret = array2table(nan(size(nav)),'VariableNames',nav.Properties.VariableNames); 
    ret.date = nav.date;
    
    ret_lag3d = ret;
    ret_lag3d.Properties.VariableNames = ['date',strcat(ret.Properties.VariableNames(2:end),'_lag3d')];
    ret_lag2d = ret_lag3d;
    ret_lag1d = ret_lag3d;
    ret_mean3d = ret_lag3d;
    ret_mean3d.Properties.VariableNames = ['date',strcat(ret.Properties.VariableNames(2:end),'_mean3d')];

    for i = 1:length(reb)

        if(i<length(reb))
            ret(i,2:end) = array2table(table2array(raw(Locb(i+1),2:end))./table2array(raw(Locb(i),2:end)) - 1);
            if(Locb(i+1)+3 <= length(raw.date))
                ret_lag3d(i,2:end) = array2table(table2array(raw(Locb(i+1)+3,2:end))./table2array(raw(Locb(i)+3,2:end)) - 1);
                ret_lag2d(i,2:end) = array2table(table2array(raw(Locb(i+1)+2,2:end))./table2array(raw(Locb(i)+2,2:end)) - 1); 
                ret_lag1d(i,2:end) = array2table(table2array(raw(Locb(i+1)+1,2:end))./table2array(raw(Locb(i)+1,2:end)) - 1);
                ret_mean3d(i,2:end) = array2table(1/3 * table2array(ret_lag3d(i,2:end)) + 1/3 * table2array(ret_lag2d(i,2:end)) + 1/3 * table2array(ret_lag1d(i,2:end)));
            else
                ret_lag3d(i,2:end)= array2table(table2array(raw(end,2:end))./table2array(raw(Locb(i)+3,2:end)) - 1); %ret(i,2:end);
                ret_lag2d(i,2:end)= array2table(table2array(raw(end,2:end))./table2array(raw(Locb(i)+2,2:end)) - 1);  %ret(i,2:end);
                ret_lag1d(i,2:end)= array2table(table2array(raw(end,2:end))./table2array(raw(Locb(i)+2,2:end)) - 1);  %ret(i,2:end);
                ret_mean3d(i,2:end) = array2table(1/3 * table2array(ret_lag3d(i,2:end)) + 1/3 * table2array(ret_lag2d(i,2:end)) + 1/3 * table2array(ret_lag1d(i,2:end))); %ret(i,2:end); % 信号触发后三天的平均价
            end
        else
            ret(i,2:end)= array2table(table2array(raw(end,2:end))./table2array(raw(Locb(i),2:end))-1);
            ret_lag3d(i,2:end)= ret(i,2:end);
            ret_lag2d(i,2:end)= ret(i,2:end);
            ret_lag1d(i,2:end)= ret(i,2:end);
            ret_mean3d(i,2:end) = ret(i,2:end); % 信号触发后三天的平均价
        end
        
    end
    
    result = array2table(nan(length(Locb),0));
    raw_ret = array2table(nan(size(raw)));
    raw_ret(2:end,2:end) = array2table(table2array(raw(2:end,2:end))./table2array(raw(1:end-1,2:end)) - 1);
    raw_ret.Properties.VariableNames = raw.Properties.VariableNames;
    for k = 2:size(raw_ret,2)
        factor_name = raw_ret.Properties.VariableNames{k};
        eval(['result.mean_',factor_name,' = nan(height(result),1);']);
        
        eval(['result.vol_',factor_name,'_1 = nan(height(result),1);']);
        eval(['result.vol_',factor_name,'_3 = nan(height(result),1);']);
        eval(['result.vol_',factor_name,'_6 = nan(height(result),1);']);

        for i = 1:length(Locb)

            if(i>1)
                eval(['result.mean_',factor_name,'(i)= mean(raw_ret.',factor_name,'((Locb(i-1)+1):Locb(i)));']);
                eval(['result.vol_',factor_name,'_1(i)= std(raw_ret.',factor_name,'((Locb(i-1)+1):Locb(i)));']);
            else
                eval(['result.mean_',factor_name,'(i) = mean(raw_ret.',factor_name,'(1:Locb(i)));']);
                eval(['result.vol_',factor_name,'_1(i)= std(raw_ret.',factor_name,'(1:Locb(i)));']);
            end
            
            if(i>3)
                eval(['result.vol_',factor_name,'_3(i)= std(raw_ret.',factor_name,'((Locb(i-3)+1):Locb(i)));']);
            else
                eval(['result.vol_',factor_name,'_3(i)= std(raw_ret.',factor_name,'(3:Locb(i)));']);
            end
            
            if(i>6)
                eval(['result.vol_',factor_name,'_6(i)= std(raw_ret.',factor_name,'((Locb(i-6)+1):Locb(i)));']);
            else
                eval(['result.vol_',factor_name,'_6(i)= std(raw_ret.',factor_name,'(6:Locb(i)));']);
            end
            
        end    
    end
    
    ret = [ret,ret_lag3d(:,2:end),ret_mean3d(:,2:end),result];

end

