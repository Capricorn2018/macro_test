function [qt,rtn] = quater_rtn(times,nav)
%
    yr = year(times);
    yr = unique(yr);
    
    j = 1;
    qt = nan(length(yr)*4,1);
    for i=1:length(yr)
        qt(j) = datenum(yr(i),3,31);
        qt(j+1) = datenum(yr(i),6,30);
        qt(j+2) = datenum(yr(i),9,30);
        qt(j+3) = datenum(yr(i),12,31);
        j = j + 4;
    end
    
    idx = nan(length(qt),1);
    
    for j=1:length(qt)
        
        if qt(j)>max(times) || qt(j)<min(times)
        else
            [~,idx(j)] = max(times(times<= qt(j)));
        end
        
    end
    
    qt = qt(~isnan(idx));
    idx = idx(~isnan(idx));
    
    rtn = nan(length(qt),1);
    
    for j=1:length(qt)        
        
        if j==1
            rtn(j) = nav(idx(j))/nav(1) - 1;
        else
            rtn(j) = nav(idx(j))/nav(idx(j-1)) - 1;
        end
        
    end
    
end

