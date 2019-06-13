function [nav,ret,reb] = load_assets(filename,num_days,direction)

     raw = readtable(filename);
     
    raw.Properties.VariableNames(1) = {'date'};
    raw.date = datenum(raw.date);

    reb = find_month_dates(num_days,raw.date,direction);

    [~,Locb] = ismember(reb,raw.date);

    nav = raw(Locb,:);
    ret = array2table(nan(size(nav)),'VariableNames',nav.Properties.VariableNames);
    ret.date = nav.date;
    
    ret_lag3d = ret;
    ret_lag3d.Properties.VariableNames = ['date',strcat(nav.Properties.VariableNames(2:end),'_lag3d')];

    for i = 1:length(reb)

        if(i<length(reb))
            ret(i,2:end) = array2table(table2array(raw(Locb(i+1),2:end))./table2array(raw(Locb(i),2:end)) - 1);
            ret_lag3d(i,2:end) = array2table(table2array(raw(Locb(i+1)+3,2:end))./table2array(raw(Locb(i)+3,2:end)) - 1);
        else
            ret(i,2:end)= array2table(nan(1,size(ret,2)-1));
            ret_lag3d(i,2:end)= array2table(nan(1,size(ret,2)-1));
        end
    end
    
    ret = [ret,ret_lag3d(:,2:end)];

end

