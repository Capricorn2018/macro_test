function p = probability(x,data,bull,bear)

    df1 = data(bull,:);
    df2 = data(bear,:);

    mu1 = mean(df1,1);
    mu2 = mean(df2,1);

    %std1 = cov(df1);
    %std2 = cov(df2);
    std1 = cov(data,'omitrows');
    std2 = std1;
    
    p = nan(size(x,1),1);
    for i=1:size(x,1)
        y = x(i,:);
        p(i) = kkt(y,mu1,mu2,std1,std2);
    end
    
end

