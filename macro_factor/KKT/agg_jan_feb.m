function res = agg_jan_feb(times,data,chg)
% 处理1~2月数据
% chg = true, 即输入的是绝对数据，需要对1月和2月加总计算
% chg = false, 即输入是同比数据，需要对1月和2月做平均
    res = data;
    mth = month(times);
    
    for i=1:length(data)
        if(mth(i)==1 && i<length(data))
            res(i) = NaN;
            if(chg)
                res(i+1) = nanmean(data(i:i+1));
            else
                res(i+1) = nansum(data(i:i+1));
            end
        else
            if(mth(i)==1 && i==length(data))
                res(i) = NaN;
            end
        end
    end
    
    if(chg)
        for j=2:12
            idx = mth==j;
            res_mth = res(idx);
            res_mth_chg = nan(length(res_mth),1);
            res_mth_chg(2:end) = res_mth(2:end)./res_mth(1:end-1) - 1;
            res(idx) = res_mth_chg;
        end
    end
end

