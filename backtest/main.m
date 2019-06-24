num_days = 5; % 倒数第5交易日
direction = 'last'; % 倒数的
assets_file = 'D:/Projects/macro_test/指数.xls';
raw = readtable(assets_file);
raw.Properties.VariableNames(1) = {'date'};
raw.date = datenum(raw.date);
reb = find_month_dates(num_days,raw.date,direction);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这里需要手动调整最后一个交易日 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reb(end) = datenum('2019/06/21');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 这里需要手动调整最后一个交易日 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[~,ret] = load_assets(assets_file,reb);

factor_file = 'D:/Projects/macro_test/国债期限利差.xls';
factor = load_factor(factor_file,reb,'sprd51');

tbl = merge_xy(factor, ret);

factor_file = 'D:/Projects/macro_test/凸度.xls';
factor = load_factor(factor_file,reb,'curv1510');

tbl = merge_xy(factor, tbl);

%factor_file = 'D:/Projects/macro_test/凸度30.xls';
%factor = load_factor(factor_file,reb,'curv11030');

%tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/国开利差.xls';
factor = load_factor(factor_file,reb,'sprdfin');

tbl = merge_xy(factor, tbl);

% 截取2005年以后的数
tbl.mom1m = tbl.CBA02551 - tbl.CBA02521;
tbl.mom1m = [NaN;tbl.mom1m(1:end-1)];
tbl.mom2m = [NaN; movsum(tbl.mom1m,2,'Endpoints','discard')];
tbl.mom3m = [NaN;NaN; movsum(tbl.mom1m,3,'Endpoints','discard')];

tbl.stk1m = [NaN;tbl.HS300(1:end-1)];
tbl.stk3m = [nan(2,1); movsum(tbl.stk1m,3,'Endpoints','discard')];

tbl.curv1510_3m = [nan(2,1);movsum(tbl.mean_curv1510,3,'Endpoints','discard')];
tbl.sprd51_3m = [nan(2,1);movsum(tbl.mean_sprd51,3,'Endpoints','discard')];
tbl.sprdfin_3m = [nan(2,1);movsum(tbl.mean_sprd51,3,'Endpoints','discard')];

tbl_orig = tbl;
tbl = tbl(year(tbl.date)>=2005,:);

r0 = tbl.CBA02511_lag3d;
r1 = tbl.CBA02521_lag3d;
r5 = tbl.CBA02531_lag3d;
r10 = tbl.CBA02551_lag3d;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mom1m = tbl.mom1m;
mom2m = tbl.mom2m;
mom3m = tbl.mom3m;

stk3m = tbl.stk3m;

sprd51 = tbl.mean_sprd51;
sprdfin = tbl.mean_sprdfin;

curv1510 = tbl.mean_curv1510;
%curv11030 = tbl.mean_curv11030;

sprd51_3m = tbl.sprd51_3m;
sprdfin_3m = tbl.sprdfin_3m;
curv1510_3m = tbl.curv1510_3m;

r_long = tbl.CBA02551_lag3d;
r_short = tbl.CBA02521_lag3d;

signal_sprd = roll_signal(sprd51,36,0.5);
[r_sprd,alpha_sprd] = long_short(r_long,r_short,signal_sprd);

signal_curv = roll_signal(curv1510,36,0.5);
[r_curv,alpha_curve] = long_short(r_long,r_short,signal_curv);

signal_sprd3m = roll_signal(sprd51_3m,36,0.5);
signal_curv3m = roll_signal(curv1510_3m,36,0.5);
signal_fin3m = roll_signal(sprdfin_3m,36,0.5);

signal_mom = mom1m>0;
[r_mom,alpha_mom] = long_short(r_long,r_short,signal_mom);

signal_mom3m = mom3m>0;
[r_mom3m,alpha_mom3m] = long_short(r_long,r_short,signal_mom3m);

signal_fin = roll_signal(sprdfin,36,0.5);
[r_fin,alpha_fin] = long_short(r_long,r_short,signal_fin);

signal_stk3m = stk3m < 0; 
[r_stk, alpha_stk] = long_short(r_long,r_short,signal_stk3m);


%%%%%%%%%%%%%%%%%%%% 最终策略 %%%%%%%%%%%%%%%%%%%%
r_found = r_short;
signal_found = (signal_sprd==1 &  signal_fin==1);
r_found(signal_found==1) = r_long(signal_found==1);

r_prev = r_short;
signal_prev = (signal_stk3m==1 & signal_mom==1);
r_prev(signal_prev==1) = r_long(signal_prev==1);

active = 0.6; % 主动长债仓位限制
signal = table(datestr(tbl.date,'yyyymmdd'),signal_found,signal_prev);
position = (signal_found) * active/2 + (signal_prev) * active/2;
r_all = r1 * (1-active) + r_prev * active/2 + r_found * active/2;
alpha = r_all - r1;
%%%%%%%%%%%%%%%%%%%% 最终策略 %%%%%%%%%%%%%%%%%%%%

nav = [1;cumprod(1+r_all)];
nav_short = [1;cumprod(1+r1)];
nav_long = [1;cumprod(1+r10)];
nav_mom = [1;cumprod(1+r_mom)];
nav_curv = [1;cumprod(1+r_curv)];
nav_sprd = [1;cumprod(1+r_sprd)];
nav_fin = [1;cumprod(1+r_fin)];
nav_stk = [1;cumprod(1+r_stk)];

figure(1);
subplot(2,1,1);
plot(nav);
hold on;
plot(nav_short);
plot(nav_long);
legend('策略净值','中债1~3年国开财富指数','中债7~10年国开财富指数','Location','Best');
title('策略净值曲线');
hold off;

subplot(2,1,2);
plot(nav_mom,'b');
hold on;
plot(nav_sprd,'r');
plot(nav_curv,'m');
plot(nav_fin,'g');
plot(nav_stk,'k');
plot(nav_short,'c');
legend('mom','sprd','curv','fin','stk','中债1~3年国开债指数','Location','Best');
title('单个因子策略净值曲线');
hold off;

figure(2);
yr = 2005:2019;
[alpha_yr,r_yr] = year_stats(alpha,r_all,tbl.date,yr);
friction = 0.002; % 摩擦成本
costs = fees(position,friction);
[costs_yr,~] = year_stats(costs,costs,tbl.date,yr);
subplot(2,2,1);
bar(yr,alpha_yr);
title('未扣费超额收益');
subplot(2,2,2);
bar(yr,costs_yr);
title(['摩擦费率0.',num2str(friction*1000),'%交易成本']);
subplot(2,2,3);
bar(yr,alpha_yr-costs_yr);
title('费后超额收益');
subplot(2,2,4);
bar(yr,r_yr-costs_yr);
title('费后绝对收益');

figure(3);
plot(position);
title('长债仓位');

figure(4);
subplot(2,1,1);
costs_p = fees(signal_prev,friction); % 假设10bps/20bps的调仓双向交易成本
[costs_p_yr,~] = year_stats(costs_p,costs_p,tbl.date,yr);
bar(yr,costs_p_yr);
title('动量策略交易成本');
subplot(2,1,2);
costs_f = fees(signal_found,friction);% 假设10bps/20bps的调仓双向交易成本
[costs_f_yr,~] = year_stats(costs_f,costs_f,tbl.date,yr);
bar(yr,costs_f_yr);
title('风险溢价交易成本');
