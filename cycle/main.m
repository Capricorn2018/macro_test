w = windmatlab;
w.menu();

credit;
prices;

econ = [inflation,array2table([NaN;fin_growth(1:end-1)])];
econ.Properties.VariableNames = [inflation.Properties.VariableNames,{'fin_growth'}];

data = movmean(table2array(econ(:,2:end)),3,1);
isnum = ~any(isnan(data),2);

data = [econ(isnum,1),array2table(data(isnum,:))];

start = datenum(2009,1,1);
bl = data.times >= start;

id = 1:length(data.times);
n_st = min(id(bl));

theta = zeros(length(data.times),1);
A = zeros(length(data.times),1);
pd = makedist('Normal',238,10);
weight = pdf(pd,1:10000);

for i = n_st:length(data.times)
    
    tmp = table2array(data(1:i,2:end));
    
    % 原始数据正规化
    tmp = (tmp - repmat(mean(tmp,1),size(tmp,1),1)) ./ repmat(std(tmp,1),size(tmp,1),1);
    
    % pca
    coeff = pca(tmp);
    coeff1 = coeff(:,1);
    
    % pca因子加权结果
    index = tmp * coeff1;
    F = fft(index((end-50):end),10000);
    
    theta(i) = angle(F(238)); % 提取42个月的相位
    A(i) = (weight * abs(F))/sum(weight);
    
end

w.close()