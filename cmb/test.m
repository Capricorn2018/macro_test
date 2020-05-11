w = windmatlab;

start_dt = '2006-06-01';
end_dt = '2020-04-24';

% 国开债1,3,5,7,10;
% 国债1,3,5,7,10
[edb_data,edb_codes,~,edb_times,~,~] = w.edb(['M1004263,M1004265,M1004267,M1004269,M1004271,',...
                                                'M1000158,M1000160,M1000162,M1000164,M1000166'],...
                                                start_dt,end_dt,'Fill=Previous'); 
edb = array2table(edb_data,'VariableNames',edb_codes);

% 国开债即期收益率1,3,5,7,10y
[edb_data2,edb_codes2,~,edb_times2,~,~] = w.edb('M1004281,M1004283,M1004285,M1004287,M1004289',start_dt,end_dt,'Fill=Previous'); 
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
 %factors.liq5y = edb.M1004267 - edb.M1000162;
 
 % 国债期限利差因子
 %  factors.bond51 = edb.M1000162 - edb.M1000158;
 %  factors.bond105 = edb.M1000166 - edb.M1000162;
 %factors.curv = edb.M1000162 * 2 - edb.M1000158 - edb.M1000162;


 reb = find_month_dates(5, ret_times, 'last'); 

 [~,Locb] = ismember(reb, factors.date);

 f = factors(Locb,:);

 [~,Locb] = ismember(reb,ret_times);
 ret = ret(Locb,:);
 y1 = ret.CBA02521; y2 = ret.CBA02551;
 y1 = [y1(2:end)./y1(1:end-1) - 1.;NaN];
 y2 = [y2(2:end)./y2(1:end-1) - 1.;NaN];
 y = y2 - y1;

 f = table2array(f);
 f = [ones(size(f,1),1),f];
 
 [~,Locb] = ismember(reb,edb_times2);
 fwd = fwd(Locb,:);
 
 y = y(1:end-1);
 fwd = fwd(1:end-1,:);
 f = f(1:end-1,:);

 window = 40;
 
 pred = nan(length(y),1);
 intercept = pred;
 
 for j=(window+1):length(y)
    
    %下面回归
    mdl = fitlm(f(1:j-1,:),y(1:j-1));
    
    pred(j) = [1,f(j,:)] * mdl.Coefficients.Estimate;
    intercept(j) = [1,mean(f(1:j-1,:),1)] *  mdl.Coefficients.Estimate;
    
 end

 w.close();

