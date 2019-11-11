start_dt = '1990-01-01';
end_dt = '2019-10-25';
file = 'D:/Projects/macro_test/IVX/IVX_data.mat'; % 储存从wind里load出数据的文件

w = windmatlab;

 % 国债即期收益率1Y,2Y,3Y,4Y,5Y
[edb_data,edb_codes,~,edb_times,~,~] = w.edb('M1001102,M1001103,M1001104,M1001105,M1001106',...
                                                start_dt,end_dt,'Fill=Previous'); 

% 国开0~1,1~3,3~5,5~7,7~10指数
[wsd_data,~,~,wsd_times,~,~] = w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS',...
                                        'close',start_dt,end_dt);
                                   
edb = array2table(edb_data,'VariableNames',edb_codes);

factors = table();
factors.date = edb_times;
factors.spot1y = edb.M1001102;
factors.fwd1y2y = 2*edb.M1001103 - edb.M1001102;   % 1Y~2Y的远期利率
factors.fwd2y3y = 3*edb.M1001104 - 2*edb.M1001103; % 2Y~3Y的远期利率
factors.fwd3y4y = 4*edb.M1001105 - 3*edb.M1001104; % 3Y~4Y的远期利率
factors.fwd4y5y = 5*edb.M1001106 - 4*edb.M1001105; % 4Y~5Y的远期利率

names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551'};
assets = array2table([wsd_times,wsd_data],'VariableNames',names);

save(filename,'assets','factors');                                   

reb = get_dates(file,5,'last');

reb(end) = datenum('2019-10-25'); % 这里一般用每个月倒数第五个交易日
[~,ret] = load_assets(file,reb); 

factor = load_factor(file,reb);
tbl = merge_xy(factor, ret);

tbl_orig = tbl;
tbl = tbl(year(tbl.date)>=2005,:);

r0 = tbl.CBA02511_lag3d; % 0~1
r1 = tbl.CBA02521_lag3d; % 1`3
r5 = tbl.CBA02531_lag3d; % 3~5
r10 = tbl.CBA02551_lag3d; % 7~10

yt = r5-r1;
xt = tbl(:,['spot1y','fwd1y2y','fwd2y3y','fwd3y4y','fwd4y5y']);

% 下面这个是东方金工给我的那个py的函数, 输出怎么用我还没有太搞清楚
% ivxlh(yt,xt,1);
                                            


