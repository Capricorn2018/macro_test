function signal = mom_signal(signal_in,signal_out)
%MOM_SIGNAL 此处显示有关此函数的摘要
%   此处显示详细说明

    signal = signal_in;
    
    for i=2:length(signal)
       
        if(signal(i-1)==1)
            
            if(signal_out(i)==0)
                signal(i)=0;
            end
            
        end
        
    end

end

