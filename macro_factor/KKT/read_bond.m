

start_dt = '2005-01-01';
end_dt = '2020-07-31';

w = windmatlab;

% �ھ����������ͬ�ȣ�ˮ��۸�ָ������ͬ�ȣ�100+��������ˮ��۸�ָ����2011���,��Ƶ��
% �ص���ҵ�ֲָ���������ʯ�ۿڿ�棨�ܣ�����������Թ�˾���ʲ������ҵ������ʲ�
% ��Ԫָ����LMEͭ�ֻ�����ۣ��׶ػƽ��ֻ��ۣ�10Y��ծ������
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
cement_old = data(:,2) - 100; cement_old = agg_jan_feb(times,cement_old,false);% ˮ�����ݱȽ���֣���ͬ��+100 
cement_new = agg_jan_feb(times,data(:,3),true) * 100;
steel = agg_jan_feb(times,data(:,4),true);
ore = agg_jan_feb(times,data(:,5),true);
multiplier = agg_jan_feb(times,data(:,6)./data(:,7),true); 
dollar = data(:,8);
coppergold = data(:,9)./data(:,10);
yield = [NaN; data(2:end,11)-data(1:end-1,11)];

cement = cement_old;
cement(times>=datenum(2012,10,01)) = cement_new(times>=datenum(2012,10,01)); % �¾�����ƴ��

df = table(times,times_str,excavator,cement,steel,ore,multiplier,dollar,coppergold,yield);

jan = month(times)==1;
df = df(~jan,:); % ȥ��1��
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

yield_chg = [factor.yield(3:end);nan(2,1)];
plot(factor.times,prob);
hold on;
plot(factor.times,yield_chg);
datetick('x','yyyy','keeplimits');
hold off;

