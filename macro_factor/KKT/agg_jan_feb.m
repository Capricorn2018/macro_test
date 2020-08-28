function res = agg_jan_feb(times,data,chg)
% ����1~2������
% chg = true, ��������Ǿ������ݣ���Ҫ��1�º�2�¼��ܼ���
% chg = false, ��������ͬ�����ݣ���Ҫ��1�º�2����ƽ��
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

