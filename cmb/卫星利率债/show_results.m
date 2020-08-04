function [nav,nav_alpha,nav_dt] = show_results(reb, signal, r1, r10, ret_dt)
    
    [~,Locb] = ismember(reb, ret_dt);
    s = Locb(1);
    e = Locb(end);
    
    
    daily_signal = zeros(length(ret_dt),1);
    for i = 1:(length(reb)-1)
        i1 = Locb(i)+1;
        i2 = Locb(i+1);
        daily_signal(i1:i2) = signal(i);
    end
    
    r1 = r1(s:e);
    r10 = r10(s:e);
    ret_dt = ret_dt(s:e);
    daily_signal = daily_signal(s:e);
    
    r = r1;
    r(daily_signal==1) = r10(daily_signal==1);
    
    bench = r1;
    alpha = r - bench;
    
    nav = cumprod(1+r);
    nav_dt = ret_dt;
    
    figure(2);
    plot(nav_dt,nav);
    datetick('x','yyyy','keeplimits');
    title('策略净值曲线','FontSize',16);
    
    nav_alpha = cumprod(1+alpha);
    
    figure(3);
    plot(nav_dt,nav_alpha);
    datetick('x','yyyy','keeplimits');
    title('相对中债1-3年国开债指数累计超额曲线','FontSize',16);

end

