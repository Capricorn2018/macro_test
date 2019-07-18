function costs = fees(position,fee)
%FEES 此处显示有关此函数的摘要
%   此处显示详细说明
    costs = zeros(length(position),1);
    
    reb = zeros(length(position),1);
    
    reb(2:end) = abs(position(2:end) - position(1:end-1));
    
    costs = reb * fee;

end

