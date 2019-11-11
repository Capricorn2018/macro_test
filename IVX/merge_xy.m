function result = merge_xy(factor, ret)
% 把factor和需要预测的return或者alpha数据按照日期合并
    
    fd = factor.date;
    rd = ret.date;
    
    [date,ia,ib] = intersect(fd,rd);
        
    result = [array2table(date),factor(ia,2:end),ret(ib,2:end)];

end

