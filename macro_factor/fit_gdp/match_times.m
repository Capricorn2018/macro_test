function idx = match_times(stk_times,macro_times)
%MATCH_STKMACRO 此处显示有关此函数的摘要
%   此处显示详细说明
    times = [stk_times;macro_times];
    times = sort(times);
    
    [Lia_s,Loc_s] = ismember(stk_times,times);
    [~,Loc_m] = ismember(macro_times,times);
    
    map = nan(length(times),1);
    map(Lia_s) = Loc_s;
    
    for i = 2:length(times)         
        if isnan(map(i))
            map(i) = map(i-1);
        end
    end

    [~,tmp] = ismember(times(map(Loc_m)),stk_times);
    
    idx = tmp;
    idx([false;tmp(2:end)==tmp(1:end-1)]) = NaN;

end

