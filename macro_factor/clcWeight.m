% 主体名称 names
% 原始比例 orig_pct
function pct = clcWeight(names,orig_pct)
    
    % 按主体加总比例
    name_sum = zeros(length(orig_pct),1);
    for i=1:length(orig_pct)
        name_sum(i) = sum(orig_pct(names==names(i)));
    end
    
    % 没有主体比例大于5%的直接返回
    bl = name_sum > 0.05;
    if ~any(bl)
        pct = orig_pct;
        return;
    end
    
    % 对于主体比例大于5%的，按比例缩小
    pct = orig_pct;
    pct(bl) = pct(bl) * 0.05./name_sum(bl);
    
    % 计算将主体比例大于5%的券设为5%之后剩余的比例
    diff = 1 - sum(pct);
    
    % 找到主体比例小于5%的券，用于分配diff
    bl = name_sum < 0.05;
    
    % 主体比例小于5%的券总比例
    s = sum(pct(bl));
    
    % 按照占总比例的比重分配diff
    rate = pct(bl)/s;
    pct(bl) = pct(bl) + diff * rate;
    
    % 递归 
    pct = clcWeight(names,pct);

end