assets_file = 'D:/Projects/macro_test/国开债指数.xlsx';
[~,ret,reb] = load_assets(assets_file,5,'last');

factor_file = 'D:/Projects/macro_test/国债期限利差.xls';
factor = load_factor(factor_file,reb,'sprd51');

tbl = merge_xy(factor, ret);

factor_file = 'D:/Projects/macro_test/凸度.xls';
factor = load_factor(factor_file,reb,'curv1510');

tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/凸度30.xls';
factor = load_factor(factor_file,reb,'curv11030');

tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/国开利差.xls';
factor = load_factor(factor_file,reb,'sprdfin');

tbl = merge_xy(factor, tbl);

% 截取2005年以后的数
tbl.mom = tbl.CBA02551 - tbl.CBA02521;
tbl.mom = [NaN;tbl.mom(1:end-1)];

tbl_orig = tbl;
tbl = tbl(year(tbl.date)>=2005,:);

r0 = tbl.CBA02511_lag3d;
r1 = tbl.CBA02521_lag3d;
r5 = tbl.CBA02531_lag3d;
r10 = tbl.CBA02551_lag3d;

mom1 = tbl.mom;

sprd51 = tbl.mean_sprd51;
sprdfin = tbl.mean_sprdfin;

curv1510 = tbl.mean_curv1510;
curv11030 = tbl.mean_curv11030;

r_long = r10;

signal = roll_signal(sprd51,60,0.5);
r_sprd = zeros(length(r1),1);
r_sprd(signal==1) = r_long(signal==1);
r_sprd(signal~=1) = r1(signal~=1);

r_mom = zeros(length(r1),1);
r_mom(mom1>0) = r_long(mom1>0);
r_mom(mom1<=0) = r1(mom1<=0);

r_all = r_mom/4 + r_sprd/4 + r1/2;

nav = [1;cumprod(1+r_all)];
nav1 = [1;cumprod(1+r1)];
nav_long = [1;cumprod(1+r_long)];

hold on;
plot(nav);
plot(nav1);
plot(nav_long);
hold off;

alpha = r_all - tbl.CBA02521;

yr = 2005:2019;
alpha_yr = zeros(length(yr),1);
r_yr = zeros(length(yr),1);

for i=1:length(yr)
	alpha_yr(i) = prod(1+alpha(year(tbl.date)==yr(i))) - 1;
	r_yr(i) = prod(1+r_all(year(tbl.date)==yr(i))) - 1;
end
	
bar(alpha_yr);
