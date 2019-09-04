function param = pca_test(x,n,m)
% 用pca给参数x降维, 初始想法是x的每一列是一个利差数据
% n是最初要用到多少数据, 比如从有数据之后40个月开始
% m是滚动窗口长度, 比如40个月

    param = nan(size(x));
    
    if(istable(x))
        x = table2array(x);
    end

    for i = n:size(x,1)
        coeff = pca(x((i-m+1):i,:));
        param(i,:) = coeff(:,1)';
    end

end

