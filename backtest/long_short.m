function [ret,alpha] = long_short(r_long,r_short,signal)
%LONG_SHORT �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    
    ret = zeros(length(r_short),1);
    
    ret(signal==1) = r_long(signal==1);
    ret(signal~=1) = r_short(signal~=1);
    
    alpha = ret - r_short;

end

