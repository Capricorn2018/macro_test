w = windmatlab;

start_dt = '2006-06-01';
end_dt = '2020-1-10';

% 国开债1,3,5,7,10;
% 国债1,3,5,7,10
[edb_data,edb_codes,~,edb_times,~,~] = w.edb(['M1004263,M1004265,M1004267,',...
                                              'M1004269,M1004271,M1000158,',...
                                              'M1000160,M1000162,M1000164,',...
                                              'M1000166'],...
                                        start_dt,end_dt,'Fill=Previous'); 
edb = array2table(edb_data,'VariableNames',edb_codes);

%这次没有用到
% 国开0~1,1~3,3~5,5~7,7~10,沪深300,中债高信用1~3
[ret_data,ret_codes,~,ret_times,~,~] = w.wsd(['CBA02511.CS,CBA02521.CS,',...
                                              'CBA02531.CS,CBA02541.CS,',...
                                              'CBA02551.CS,399300.SZ,',...
                                              'CBA01921.CS'],'close',start_dt,end_dt);
names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551','HS300','CBA01921'};
ret = array2table([ret_times,ret_data],'VariableNames',names);

factors = table();

% 期限利差因子
factors.date = edb_times;
factors.sprd101 = edb.M1004271 - edb.M1004263;

% 流动性溢价因子, 用国开5-国债5
factors.liq5y = edb.M1004267 - edb.M1000162;

% 生成调仓日，这里用的是每个月第二个工作日
reb = find_month_dates(2, ret_times, 'first'); 

% 调仓日的数据对齐
[~,Locb] = ismember(reb, factors.date);
f = factors(Locb,2:end);

% 指数收益的数据对齐，计算超额收益
[~,Locb] = ismember(reb,ret_times);
ret_reb = ret(Locb,:);
y1 = ret_reb.CBA02521; y2 = ret_reb.CBA02551;
y1 = [y1(2:end)./y1(1:end-1) - 1.;NaN];
y2 = [y2(2:end)./y2(1:end-1) - 1.;NaN];
y = y2 - y1;

% 加一列截距项
f = table2array(f);
f = [ones(size(f,1),1),f];


% 试一下动量, AIC分析大概自回归2周，这里为了降频就用上个月
prev = [NaN;y(1:end-1)];
f = [f, prev];

% 试一下卫星数据
% 这个数据在15年3月之前用的PMI
% 15年3月之后用的PMI和灯光数据的加权
% PMI数据都取的实际值减去15年3月之后的均值，再除以方差
% 灯光数据类似PMI的处理
% 二者加权用的是类似PCA的方法 ((a-mean(a))/std(a) + (b-mean(b))/std(b))/(1+rho)
% 这里面有一定的数据回看的成分，比如说均值和方差，但是卫星数据实在历史太短也没办法
[res,~,~] = read_satellite(reb);
f = [f,res];

% 去掉最后一期的数据缺失
y = y(1:end-1);
f = f(1:end-1,:);


% 初始窗口40个月是傅里叶分析得出的主周期
window = 40;

% 预测结果
pred = nan(length(y),1);

for j=(window+1):length(y)

    % 下面回归
    mdl = fitlm(f(1:j-1,:),y(1:j-1));

    % 用下期的因子数据和本期的回归结果计算预测数据
    pred(j) = [1,f(j,:)] * mdl.Coefficients.Estimate;

end

signal = pred > 0;
close1 = ret.CBA02521;
close10 = ret.CBA02551;
r1 = [NaN;close1(2:end)./close1(1:end-1) - 1];
r10 = [NaN;close10(2:end)./close10(1:end-1) - 1];
ret_dt = ret_times;

[nav,nav_alpha,nav_dt] = show_results(reb, signal, r1, r10, ret_dt);

w.close();

