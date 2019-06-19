assets_file = 'D:/Projects/macro_test/ָ��.xls';
[~,ret,reb] = load_assets(assets_file,5,'last');

factor_file = 'D:/Projects/macro_test/��ծ��������.xls';
factor = load_factor(factor_file,reb,'sprd51');

tbl = merge_xy(factor, ret);

factor_file = 'D:/Projects/macro_test/͹��.xls';
factor = load_factor(factor_file,reb,'curv1510');

tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/͹��30.xls';
factor = load_factor(factor_file,reb,'curv11030');

tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/��������.xls';
factor = load_factor(factor_file,reb,'sprdfin');

tbl = merge_xy(factor, tbl);

% ��ȡ2005���Ժ����
tbl.mom1m = tbl.CBA02551 - tbl.CBA02521;
tbl.mom1m = [NaN;tbl.mom1m(1:end-1)];
tbl.mom2m = [NaN; movsum(tbl.mom1m,2,'Endpoints','discard')];
tbl.mom3m = [NaN;NaN; movsum(tbl.mom1m,3,'Endpoints','discard')];

tbl.stk1m = [NaN;tbl.HS300(1:end-1)];
tbl.stk3m = [nan(2,1); movsum(tbl.stk1m,3,'Endpoints','discard')];

tbl_orig = tbl;
tbl = tbl(year(tbl.date)>=2005,:);

r0 = tbl.CBA02511_lag3d;
r1 = tbl.CBA02521_lag3d;
r5 = tbl.CBA02531_lag3d;
r10 = tbl.CBA02551_lag3d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mom1 = tbl.mom1m;
mom2 = tbl.mom2m;
mom3 = tbl.mom3m;

stk3m = tbl.stk3m;

sprd51 = tbl.mean_sprd51;
sprdfin = tbl.mean_sprdfin;

curv1510 = tbl.mean_curv1510;
curv11030 = tbl.mean_curv11030;

r_long = r10;
r_short = r1;

signal_sprd = roll_signal(sprd51,36,0.5);
[r_sprd,alpha_sprd] = long_short(r_long,r_short,signal_sprd);

signal_curv = roll_signal(curv1510,36,0.5);
[r_curv,alpha_curve] = long_short(r_long,r_short,signal_curv);

signal_mom = mom1>0;
[r_mom,alpha_mom] = long_short(r_long,r_short,signal_mom);

signal_fin = roll_signal(sprdfin,36,0.5);
[r_fin,alpha_fin] = long_short(r_long,r_short,signal_fin);

signal_stk3m = stk3m < 0; 
[r_stk, alpha_stk] = long_short(r_long,r_short,signal_stk3m);


% �������Ը���1/4��Ȩ��,Ҳ���������ڹ���Ҳ��4����
% r_all = r_mom/8 + r_sprd/8 + r_fin/8 + r_stk/8 + r1/2;
% r_all = r_mom/6 + r_sprd/6 + r_fin/6 + r1/2;

r_found = r_short;
r_found(signal_curv==1 & signal_fin==1) = r_long(signal_curv==1 & signal_fin==1);

r_prev = r_short;
r_prev(signal_stk3m==1 & signal_mom==1) = r_long(signal_stk3m==1 & signal_mom==1);

r_all = r1/3 + r_prev/3 + r_found/3;
alpha = r_all - r1;

nav = [1;cumprod(1+r_all)];
nav_short = [1;cumprod(1+r_short)];
nav_long = [1;cumprod(1+r_long)];
nav_mom = [1;cumprod(1+r_mom)];
nav_curv = [1;cumprod(1+r_curv)];
nav_sprd = [1;cumprod(1+r_sprd)];
nav_fin = [1;cumprod(1+r_fin)];
nav_stk = [1;cumprod(1+r_stk)];

figure(1);
plot(nav);
hold on;
plot(nav_short);
plot(nav_long);
legend('���Ծ�ֵ','��ծ1~3������Ƹ�ָ��','��ծ7~10������Ƹ�ָ��','Location','Best');
hold off;

figure(2);
plot(nav_mom,'b');
hold on;
plot(nav_sprd,'r');
plot(nav_curv,'m');
plot(nav_fin,'g');
plot(nav_stk,'k');
plot(nav_short,'c');
legend('mom','sprd','curv','fin','stk','��ծ1~3�����ծָ��','Location','Best');
hold off;

figure(3);
yr = 2005:2019;
[alpha_yr,r_yr] = year_stats(alpha,r_all,tbl.date,yr);
bar(yr,alpha_yr);

figure(4);
position = (signal_curv==1 & signal_fin==1)/3 + (signal_mom==1 & signal_stk3m==1)/3;
plot(position);

figure(5);
bar(yr,r_yr);
