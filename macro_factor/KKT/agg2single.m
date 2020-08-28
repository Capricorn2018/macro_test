function res = agg2single(times,data)
% 将累计数差分计算当月（季）数
    yr = year(times);
    
    d = data(~isnan(data));
    yr = yr(~isnan(data));
    
    two_yr = mink(yr,2);
    frst_yr = two_yr(1);
    sec_yr = two_yr(2);
    N1 = length(yr(yr==frst_yr));
    N2 = length(yr(yr==sec_yr));
    
    
    frst = true(length(yr),1);
    frst(2:end) = yr(2:end)~=yr(1:end-1);
    if(N1==N2)
        frst(1) = true;
    else
        frst(1) = false;
    end
    
    single = nan(length(d),1);
    single(2:end) = d(2:end) - d(1:end-1);
    
    single(frst) = d(frst);
    
    res = nan(length(data),1);
    res(~isnan(data)) = single;
    
end

