function [nav,ret] = load_assets(filename,reb)

    %raw = readtable(filename);
    x = load(filename);
    raw = x.assets;
     
    %raw.Properties.VariableNames(1) = {'date'};
    %raw.date = datenum(raw.date);

    %reb = find_month_dates(num_days,raw.date,direction);

    [~,Locb] = ismember(reb,raw.date);
    
    Locb = Locb(Locb>0); % 去掉不在raw.date里面的

    nav = raw(Locb,:);
    ret = array2table(nan(size(nav)),'VariableNames',nav.Properties.VariableNames);
    ret.date = nav.date;
    
    ret_lag3d = ret;
    ret_lag3d.Properties.VariableNames = ['date',strcat(nav.Properties.VariableNames(2:end),'_lag3d')];
    ret_lag2d = ret_lag3d;
    ret_lag1d = ret_lag3d;
    ret_mean3d = ret_lag3d;
    ret_mean3d.Properties.VariableNames = ['date',strcat(nav.Properties.VariableNames(2:end),'_mean3d')];

    for i = 1:length(reb)

        if(i<length(reb))
            ret(i,2:end) = array2table(table2array(raw(Locb(i+1),2:end))./table2array(raw(Locb(i),2:end)) - 1);
            if(Locb(i+1)+3 <= length(raw.date))
                ret_lag3d(i,2:end) = array2table(table2array(raw(Locb(i+1)+3,2:end))./table2array(raw(Locb(i)+3,2:end)) - 1);
                ret_lag2d(i,2:end) = array2table(table2array(raw(Locb(i+1)+2,2:end))./table2array(raw(Locb(i)+2,2:end)) - 1); 
                ret_lag1d(i,2:end) = array2table(table2array(raw(Locb(i+1)+1,2:end))./table2array(raw(Locb(i)+1,2:end)) - 1);
                ret_mean3d(i,2:end) = array2table(1/3 * table2array(ret_lag3d(i,2:end)) + 1/3 * table2array(ret_lag2d(i,2:end)) + 1/3 * table2array(ret_lag1d(i,2:end)));
            else
                ret_lag3d(i,2:end)= ret(i,2:end);
                ret_lag2d(i,2:end)= ret(i,2:end);
                ret_lag1d(i,2:end)= ret(i,2:end);
                ret_mean3d(i,2:end) = ret(i,2:end);
            end
        else
            ret(i,2:end)= array2table(table2array(raw(end,2:end))./table2array(raw(Locb(i),2:end))-1);
            ret_lag3d(i,2:end)= ret(i,2:end);
            ret_lag2d(i,2:end)= ret(i,2:end);
            ret_lag1d(i,2:end)= ret(i,2:end);
            ret_mean3d(i,2:end) = ret(i,2:end);
        end
    end
    
    ret = [ret,ret_lag3d(:,2:end),ret_mean3d(:,2:end)];

end

