

start_dt = '2005-01-01';
end_dt = '2020-07-31';

w = windmatlab;

% 工业增加值同比、PMI、固投累计总量、社消同比、出口同比、进口同比、CPI同比、PPI同比、名义GDP当季总量
[data,codes,~,times,~,~]=w.edb(['M0000545,M0017126,M0000272,M0001428,', ...
                                    'M0000607,M0000609,M0000612,M0001227,M5567876'], ...
                                    start_dt,end_dt);
times_str = datestr(times,'yyyymmdd');
times_str = mat2cell(times_str,ones(length(times_str),1),8);
                                

product = agg_jan_feb(times,data(:,1),false);
pmi = agg_jan_feb(times,data(:,2),false);
fai = agg_jan_feb(times,data(:,3),true);
consume = agg_jan_feb(times,data(:,4),false);
export = agg_jan_feb(times,data(:,5),false);
import = agg_jan_feb(times,data(:,6),false);
cpi = agg_jan_feb(times,data(:,7),false);
ppi = agg_jan_feb(times,data(:,8),false);
gdp = agg_jan_feb(times,data(:,9),true);

df = table(times_str,product,pmi,fai,consume,export,import,cpi,ppi,gdp);

jan = month(times)==1;

df = df(~jan,:); % 去掉1月
df = df(12:end,:);
t = times(~jan);
t = t(12:end);

df.pmi_mov = movmean(df.pmi,3);
                                
recession = df.pmi_mov < 50.133;
expand = df.pmi_mov > 53;
expand(130:150) = true;

df1 = df(expand,[2,4:9]);
df2 = df(recession,[2,4:9]);

df1 = table2array(df1);
df2 = table2array(df2);

mu1 = mean(df1,1);
mu2 = mean(df2,1);

std1 = cov(df1);
std2 = cov(df2);


prob = nan(height(df),1);
for i=1:height(df)
    x = df(i,[2,4:9]);
    x = table2array(x);
    prob(i) = kkt(x,mu1,mu2,std1,std2);
end
