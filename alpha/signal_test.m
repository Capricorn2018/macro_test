function [alpha,skew,alpha_avg,win_rate,signal_freq,signal_count] = signal_test(signal,r_base,r_alpha)
% 测试signal的有效性
    
    r = r_base;
    r(signal==1) = r_alpha(signal==1);
    
    alpha = r - r_base;
    
    relative = alpha(signal==1); % 相对收益
    
    win_rate = length(relative(relative>0))/length(relative);
    
    alpha_avg = mean(relative);
    
    signal_freq = length(relative) / length(alpha);
    
    signal_count = length(relative);
    
    skew = skewness(relative);

end

