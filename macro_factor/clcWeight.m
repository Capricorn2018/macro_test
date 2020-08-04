% �������� names
% ԭʼ���� orig_pct
function pct = clcWeight(names,orig_pct)
    
    % ��������ܱ���
    name_sum = zeros(length(orig_pct),1);
    for i=1:length(orig_pct)
        name_sum(i) = sum(orig_pct(names==names(i)));
    end
    
    % û�������������5%��ֱ�ӷ���
    bl = name_sum > 0.05;
    if ~any(bl)
        pct = orig_pct;
        return;
    end
    
    % ���������������5%�ģ���������С
    pct = orig_pct;
    pct(bl) = pct(bl) * 0.05./name_sum(bl);
    
    % ���㽫�����������5%��ȯ��Ϊ5%֮��ʣ��ı���
    diff = 1 - sum(pct);
    
    % �ҵ��������С��5%��ȯ�����ڷ���diff
    bl = name_sum < 0.05;
    
    % �������С��5%��ȯ�ܱ���
    s = sum(pct(bl));
    
    % ����ռ�ܱ����ı��ط���diff
    rate = pct(bl)/s;
    pct(bl) = pct(bl) + diff * rate;
    
    % �ݹ� 
    pct = clcWeight(names,pct);

end