function signal = value_signal(value_ret,bond_ret,threshold)
    signal = zeros(length(value_ret),1);
    for i=13:length(value_ret)
        r3 = prod(value_ret((i-2):i) + 1) - 1;
        r12 = (prod(value_ret((i-12):(i-1)) + 1))^(1/4) - 1;
        
        if r3>r12 && bond_ret(i)<-threshold
            signal(i) = -1;
        else
            if r3<r12 && bond_ret(i)>threshold
                signal(i) = 1;
            end
        end
    end
end

