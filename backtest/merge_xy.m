function result = merge_xy(factor, ret)
% ��factor����ҪԤ���return����alpha���ݰ������ںϲ�
    
    fd = factor.date;
    rd = ret.date;
    
    [date,ia,ib] = intersect(fd,rd);
        
    result = [array2table(date),factor(ia,2:end),ret(ib,2:end)];

end

