function costs = fees(position,fee)
%FEES �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    costs = zeros(length(position),1);
    
    reb = zeros(length(position),1);
    
    reb(2:end) = abs(position(2:end) - position(1:end-1));
    
    costs = reb * fee;

end

