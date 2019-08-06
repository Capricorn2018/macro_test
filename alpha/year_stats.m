function [alpha_yr,r_yr] = year_stats(alpha,ret,date,yr)
% 每年的alpha数据
    alpha_yr = zeros(length(yr),1);
    r_yr = zeros(length(yr),1);

    alpha_nan = alpha;
    alpha_nan(isnan(alpha_nan)) = 0;
    
    r_nan = ret;
    r_nan(isnan(ret)) = 0;
    
    dt_yr = year(date);
    if month(date(end))==12
        dt_yr = [dt_yr(2:end);dt_yr(end)+1];
    else
        dt_yr = [dt_yr(2:end);dt_yr(end)];
    end

    for i=1:length(yr)
        alpha_yr(i) = prod(1+alpha_nan(dt_yr==yr(i))) - 1;
        r_yr(i) = prod(1+r_nan(dt_yr==yr(i))) - 1;
    end


end

