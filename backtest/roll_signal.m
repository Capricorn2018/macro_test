function signal = roll_signal(factor,period,percent)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
    signal = zeros(length(factor),1);
    
    for i = period:length(factor)
        
        f = factor((i-period+1):i);
        
        if percent > 0.5
            disp('percent > 0.5');
        end
        
        long_q = quantile(f,percent);
        short_q = quantile(f,1-percent);
        
        if factor(i) > long_q
            signal(i) = 1;
        else
            if factor(i) < short_q
                signal(i) = -1;
            end
        end
        
    end

end

