function signal = roll_signal(factor1,factor2,period,percent)
% ��factor1�Ƿ񳬹���factor2�ڶ�Ӧperiod��֮�ڵķ�λ��
    
    signal = zeros(length(factor1),1);
    
    for i = period:length(factor1)
        
        f = factor2((i-period+1):i);
        
        if percent > 0.5
            disp('percent > 0.5');
        end
        
        long_q = quantile(f,1-percent);
        short_q = quantile(f,percent);
        
        if factor1(i) > long_q
            signal(i) = 1;
        else
            if factor1(i) < short_q
                signal(i) = -1;
            end
        end
        
    end

end

