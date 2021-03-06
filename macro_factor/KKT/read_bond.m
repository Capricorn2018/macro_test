

start_dt = '2005-01-01';
end_dt = '2020-08-31';

w = windmatlab;

% 挖掘机销量当月同比，水泥价格指数当月同比（100+比例），水泥价格指数（2011年后,日频）
% 重点企业粗钢产量，铁矿石港口库存（周），其他存款性公司总资产，货币当局总资产
% 美元指数，LME铜现货结算价，伦敦黄金现货价，10Y国债收益率
[data,codes,~,times,~,~] = w.edb(['S6002167,S0034834,S5914515,S5700047,', ...
                                    'S0110152,M0001714,M0001689,M0000271,', ...
                                    'S0029751,S0031645,S0059749'], ...
                                    start_dt,end_dt);
data(:,3) = fillmissing(data(:,3),'previous');
data(:,5) = fillmissing(data(:,5),'previous');
data(:,8) = fillmissing(data(:,8),'previous');
data(:,9) = fillmissing(data(:,9),'previous');
data(:,10) = fillmissing(data(:,10),'previous');
data(:,11) = fillmissing(data(:,11),'previous');

idx = ~isnan(data(:,7));

data = data(idx,:);         
times = times(idx);

times_str = datestr(times,'yyyymmdd');
times_str = mat2cell(times_str,ones(length(times_str),1),8);

excavator = agg_jan_feb(times,data(:,1),false);
cement_old = data(:,2) - 100; 
cement_old = agg_jan_feb(times,cement_old,false);% 水泥数据比较奇怪，是同比+100 
cement_new = agg_jan_feb(times,data(:,3),true) * 100;
steel = agg_jan_feb(times,data(:,4),true) * 100;
ore = agg_jan_feb(times,data(:,5),true) * 100;
multiplier =  - agg_jan_feb(times,data(:,6)./data(:,7),true) * 100; 
dollar = agg_jan_feb(times,data(:,8),true) * 100;
coppergold = agg_jan_feb(times,data(:,9)./data(:,10),true) * 100;
yield = [NaN; data(2:end,11)-data(1:end-1,11)];

cement = cement_old;
cement(times>=datenum(2012,10,01)) = cement_new(times>=datenum(2012,10,01)); % 新旧数据拼接

df = table(times,times_str,excavator,cement,steel,ore,multiplier,dollar,coppergold,yield);

jan = month(times)==1;
df = df(~jan,:); % 去掉1月
times = df.times; times_str = df.times_str;

factor = df(:,[1:4,6:end]);
factor.excavator = hpfilter(factor.excavator,100);
factor.cement = hpfilter(factor.excavator,100);
factor.ore = hpfilter(factor.excavator,100);
factor.multiplier = fillmissing(factor.multiplier,'nearest');
factor.multiplier = hpfilter(factor.multiplier,100);
factor.coppergold = fillmissing(factor.coppergold,'nearest');
factor.coppergold = hpfilter(factor.coppergold,100);
factor.dollar = fillmissing(factor.dollar,'nearest');
factor.dollar = hpfilter(factor.dollar,100);
factor(2:end,3:end) = array2table(table2array(factor(2:end,3:end)) - table2array(factor(1:end-1,3:end)));
factor = factor(15:end,:);
data = factor(:,[1:4,7:end]);

%factor.dollar(2:end) = 100 * (factor.dollar(2:end) ./ factor.dollar(1:end-1) - 1);
%factor.coppergold(2:end) = 100 * (factor.coppergold(2:end) ./ factor.coppergold(1:end-1) - 1);


idx_bear = [9:18,31:39,49:53,79:85,117:127,155:157];
idx_bull = [26:30,40:45,60:63,86:107,130:141,150:154];
bull = false(height(data),1);
bear = false(height(data),1);
bull(idx_bull) = true;
bear(idx_bear) = true;

% df1 = factor(bull,3:8);
% df2 = factor(bear,3:8);
% 
% df1 = table2array(df1);
% df2 = table2array(df2);
% 
% mu1 = mean(df1,1);
% mu2 = mean(df2,1);
% 
% std1 = cov(df1);
% std2 = cov(df2);
% 
% 
% prob = nan(height(factor),1);
% for i=1:height(factor)
%     x = factor(i,3:8);
%     x = table2array(x);
%     prob(i) = kkt(x,mu1,mu2,std1,std2);
% end


test = table2array(data(:,3:end));
% test = test(2:end,:)-test(1:end-1,:);
% test = [nan(1,size(test,2));test];

prob_test = probability(test,test,bull,bear);
prob_cv = cross_validation(bull,bear,test,10);

figure(3);
plot(factor.times,prob_test);
datetick('x','yyyy','keeplimits');
hold on;
plot(factor.times,prob_cv);
hold off;


figure(4);
plot(factor.times,factor.excavator);
hold on;
plot(factor.times,factor.cement);
plot(factor.times,factor.ore);
plot(factor.times,factor.multiplier);
plot(factor.times,factor.coppergold);
plot(factor.times,-factor.dollar);
datetick('x','yyyy','keeplimits');
legend('excavator','cement','ore','multiplier','coppergold','dollar');
hold off;
