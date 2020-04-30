w = windmatlab;

start_dt = '2010-01-01';
end_dt = '2020-04-24';

% 国开债1,3,5,7,10; 国债5y                                            
[edb_data,edb_codes,~,edb_times,~,~] = w.edb('M1004263,M1004265,M1004267,M1004269,M1004271,S0059747',start_dt,end_dt,'Fill=Previous'); 
                                            
edb = array2table(edb_data,'VariableNames',edb_codes);

% 中债国债即期收益率1,3,5,7,10y
[edb_data2,edb_codes2,~,edb_times2,~,~] = w.edb('M1001102,M1001104,M1001106,M1001108,M1001110',start_dt,end_dt,'Fill=Previous'); 
                                            
edb2 = array2table(edb_data2,'VariableNames',edb_codes2);

factors = table();

% 期限利差因子
factors.date = edb_times;
factors.sprd31 = edb.M1004265 - edb.M1004263;
factors.sprd53 = edb.M1004267 - edb.M1004265;
factors.sprd105 = edb.M1004271 - edb.M1004267;

% 流动性溢价因子, 用国开5-国债5
factors.liq5y = edb.M1004267 - edb.S0059747;


reb = find_month_dates(5, factors.date, 'last'); 

[~,Locb] = ismember(reb, factors.date);

f = factors(Locb,:);

ret = edb.M1004271(Locb,:);
ret = [NaN; ret(2:end) - ret(1:end-1)];

f = table2array(f);
f = [ones(size(f,1),1),f];

%下面回归
[b,bint,r,rint,stats] = regress(ret,f);

w.close();

