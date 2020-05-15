function [res,sat,sat_dt] = read_satellite(reb_dt)

    [num,txt] = xlsread('satellite.csv');
    
    sat_dt = nan(length(txt),1);
    
    for i=1:length(txt)
        sat_dt(i) = datenum(txt{i});
    end
    
    sat = num(:,end);
    res = nan(length(reb_dt),1);
    
    for j = 1:length(sat_dt)
        idx = match_date(sat_dt(j),reb_dt);
        res(idx) = sat(j);
    end
    
end


% 这里要求调仓日reb_dt是按照日期顺序由小到大排列的
function idx = match_date(dt, reb_dt)

    if dt > max(reb_dt)
        idx = NaN;
    else
        bl = reb_dt > dt;
        [~,Locb] = ismember(1,bl);
        idx = Locb(1);
        
        if reb_dt(idx) - dt < 15
            return;
        else
            idx = NaN;
        end
                
    end
    
end

