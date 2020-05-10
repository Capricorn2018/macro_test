w = windmatlab;

start_dt = '2010-01-01';
end_dt = '2020-04-24';

% 国开债1,3,5,7,10; 国债5y                                            
[edb_data,edb_codes,~,edb_times,~,~] = w.edb('M1004263,M1004265,M1004267,M1004269,M1004271,S0059747',start_dt,end_dt,'Fill=Previous'); 
edb = array2table(edb_data,'VariableNames',edb_codes);

% 中债国债即期收益率1,3,5,7,10y
[edb_data2,edb_codes2,~,edb_times2,~,~] = w.edb('M1001102,M1001104,M1001106,M1001108,M1001110',start_dt,end_dt,'Fill=Previous'); 
edb2 = array2table(edb_data2,'VariableNames',edb_codes2);
mat = [1;3;5;7;10];
fwd = nan(size(edb_data2));
for i=1:size(fwd,1)
    fwd(i,:) = forward(edb_data2(i,:),mat)';
end

 % 国开0~1,1~3,3~5,5~7,7~10,沪深300,中债高信用1~3
 [ret_data,ret_codes,~,ret_times,~,~] = w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS,399300.SZ,CBA01921.CS','close',start_dt,end_dt);
 names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551','HS300','CBA01921'};
 ret = array2table([ret_times,ret_data],'VariableNames',names);

 factors = table();

 % 期限利差因子
 factors.date = edb_times;
 factors.sprd31 = edb.M1004265 - edb.M1004263;
 factors.sprd53 = edb.M1004267 - edb.M1004265;
 factors.sprd105 = edb.M1004271 - edb.M1004267;

 % 流动性溢价因子, 用国开5-国债5
 factors.liq5y = edb.M1004267 - edb.S0059747;


 reb = find_month_dates(5, ret_times, 'last'); 

 [~,Locb] = ismember(reb, factors.date);

 f = factors(Locb,:);

 [~,Locb] = ismember(reb,ret_times);
 ret = ret(Locb,:);
 y1 = ret.CBA02521; y2 = ret.CBA02551;
 y1 = [NaN; y1(2:end)./y1(1:end-1) - 1.];
 y2 = [NaN; y2(2:end)./y2(1:end-1) - 1.];
 y = y2 - y1;

 f = table2array(f);
 f = [ones(size(f,1),1),f];
 
 [~,Locb] = ismember(reb,edb_times2);
 fwd = fwd(Locb,:);

 %下面回归
 mdl = fitlm(fwd,y);

 w.close();

