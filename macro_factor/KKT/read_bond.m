

start_dt = '2005-01-01';
end_dt = '2020-07-31';

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
cement_old = data(:,2) - 100; cement_old = agg_jan_feb(times,cement_old,false);% 水泥数据比较奇怪，是同比+100 
cement_new = agg_jan_feb(times,data(:,3),true);
steel = agg_jan_feb(times,data(:,4),true);
ore = agg_jan_feb(times,data(:,5),true);
multiplier = data(:,6)./data(:,7); 
dollar = data(:,8);
coppergold = data(:,9)./data(:,10);
yield = [NaN; data(2:end,11)-data(1:end-1,11)];

cement = cement_old;
cement(times>=datenum(2012,10,01)) = cement_new(times>=datenum(2012,10,01)); % 新旧数据拼接

df = table(times,times_str,excavator,cement,steel,ore,multiplier,dollar,coppergold,yield);

jan = month(times)==1;
df = df(~jan,:); % 去掉1月
times = df.times; times_str = df.times_str;

factor = df(15:end,[1:4,6:end]);

bear = [9:18,31:39,49:53,79:85,117:127,155:157];
bull = [26:30,40:45,60:63,86:107,130:141,150:154];

df1 = factor(bull,3:8);
df2 = factor(bear,3:8);

df1 = table2array(df1);
df2 = table2array(df2);

mu1 = mean(df1,1);
mu2 = mean(df2,1);

std1 = cov(df1);
std2 = cov(df2);


prob = nan(height(factor),1);
for i=1:height(factor)
    x = factor(i,3:8);
    x = table2array(x);
    prob(i) = kkt(x,mu1,mu2,std1,std2);
end


%                                 
% 
% product = agg_jan_feb(times,data(:,1),false);
% pmi = agg_jan_feb(times,data(:,2),false);
% fai = agg_jan_feb(times,data(:,3),true);
% consume = agg_jan_feb(times,data(:,4),false);
% export = agg_jan_feb(times,data(:,5),false);
% import = agg_jan_feb(times,data(:,6),false);
% cpi = agg_jan_feb(times,data(:,7),false);
% ppi = agg_jan_feb(times,data(:,8),false);
% gdp = agg_jan_feb(times,data(:,9),true);
% 
% df = table(times_str,product,pmi,fai,consume,export,import,cpi,ppi,gdp);
% 
% jan = month(times)==1;
% 
% df = df(~jan,:); % 去掉1月
% df = df(12:end,:);
% t = times(~jan);
% t = t(12:end);
% 
% df.pmi_mov = movmean(df.pmi,3);
%                                 
% recession = df.pmi_mov < 50.133;
% expand = df.pmi_mov > 53;
% expand(130:150) = true;
% 
% df1 = df(expand,[2,4:9]);
% df2 = df(recession,[2,4:9]);
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
% prob = nan(height(df),1);
% for i=1:height(df)
%     x = df(i,[2,4:9]);
%     x = table2array(x);
%     prob(i) = kkt(x,mu1,mu2,std1,std2);
% end
