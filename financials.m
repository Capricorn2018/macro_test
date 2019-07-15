% 社融月数据, 社融存量月数据(2016年之前只有季度和年度更新), 社融存量年数据
[data,~,~,times,~,~]=w.edb('M5206730,M5525755,M5522880','2002-01-01','2019-07-15');

data = table(data(:,1),data(:,2),data(:,3),'VariableNames',{'fin_mth','fin_cum','fin_cumyr'});

fin_rep = nan(height(data),1);
fin_rep(1) = data.fin_cum(1);

for i = 2:height(data)

    if( ~isnan(data.fin_cum(i)) )
        fin_rep(i) = data.fin_cum(i);
    else
        if( ~isnan(fin_rep(i-1)) )
            fin_rep(i) = fin_rep(i-1) + data.fin_mth(i)/10000;
        end
    end
    
    
end


fin_growth = nan(length(fin_rep),1);
fin_growth(12:end) = fin_rep(12:end)./fin_rep(1:end-11) - 1;