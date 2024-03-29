start_dt = '1990-01-01';
end_dt = '2021-12-17';
file = 'D:/Projects/macro_test/data.mat';
file_value = 'D:/Projects/macro_test/alpha/value.xlsx';
[factors,assets] = wind_data(file,start_dt,end_dt);

reb = get_dates(file,5,'last');

reb(end) = datenum('2021-12-17'); % 这里一般用每个月倒数第五个交易日
[~,ret] = load_assets(file,file_value,reb);

factor = load_factor(file,reb);
tbl = merge_xy(factor, ret);

% 截取2005年以后的数
tbl.mom1m = tbl.CBA02551 - tbl.CBA02521;
tbl.mom1m = [NaN;tbl.mom1m(1:end-1)];
tbl.mom2m = movsum(tbl.mom1m,[1 0]);
tbl.mom3m = movsum(tbl.mom1m,[2 0]);
tbl.mom6m = movsum(tbl.mom1m,[5 0]);

tbl.stk1m = [NaN;tbl.HS300(1:end-1)];
tbl.stk3m = movsum(tbl.stk1m,[2 0]);

tbl.value = [NaN;tbl.value(1:end-1)];
tbl.comm = [NaN;tbl.NH0200(1:end-1)];

tbl.curv135_3m = movmean(tbl.mean_curv135,[2 0]);
tbl.curv1510_3m = movmean(tbl.mean_curv1510,[2 0]);
tbl.sprd31_3m = movmean(tbl.mean_sprd31,[2 0]);
tbl.sprd51_3m = movmean(tbl.mean_sprd51,[2 0]);
tbl.sprdfin_3m = movmean(tbl.mean_sprdfin,[2 0]);
tbl.sprdliq_3m = movmean(tbl.mean_sprdliq,[2 0]);

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
mom6m = tbl.mom6m;

stk3m = tbl.stk3m;
value = movmean(tbl.value,[2 0]);
comm = tbl.comm;

sprd31 = tbl.mean_sprd31;
sprd51 = tbl.mean_sprd51;
sprd51swap = tbl.mean_sprd51swap;
sprd710 = tbl.mean_sprd710;
sprdfin = tbl.mean_sprdfin;
sprdliq = tbl.mean_sprdliq;
sprdAAA = tbl.mean_sprdAAA;
taxfin = tbl.mean_taxfin;

% 利率互换是月度数据,避免数据偷看,用前一个月的数据
sprdswap = [NaN;tbl.sprdswap(1:end-1)];

curv123 = tbl.mean_curv123;
curv135 = tbl.mean_curv135;
curv1510 = tbl.mean_curv1510;

sprd51_10d = tbl.mean10_sprd51;
curv1510_10d = tbl.mean10_curv1510;
curv135_10d = tbl.mean10_curv135;

sprd31_3m = tbl.sprd31_3m;
sprd51_3m = tbl.sprd51_3m;
curv135_3m = tbl.curv135_3m;
curv1510_3m = tbl.curv1510_3m;
sprdfin_3m = tbl.sprdfin_3m;
sprdliq_3m = tbl.sprdliq_3m;

% 基准收益
r_long = tbl.CBA02551_lag3d;
r_short = tbl.CBA02521_lag3d;
r_mid = tbl.CBA02531_lag3d;
r_money = tbl.CBA02511_lag3d;

signal_value = value<0 & mom1m>0;  %value_signal(value,mom1m,0.004);%用0？？？？
[r_value,alpha_value] = long_short(r_long,r_short,signal_value);

signal_comm = -(comm>0 & mom1m<0);
[r_comm,alpha_comm] = long_short(r_long,r_short,signal_comm);

signal_sprd = roll_signal(sprd51,sprd51,40,0.5);
[r_sprd,alpha_sprd] = long_short(r_long,r_short,signal_sprd);

signal_sprd_10d = roll_signal(sprd51_10d,sprd51,40,0.5);
[r_sprd_10d,alpha_sprd_10d] = long_short(r_long,r_short,signal_sprd);

signal_sprd51swap = roll_signal(sprd51swap,sprd51swap,40,0.5);
[r_sprd51swap,alpha_sprd51swap] = long_short(r_long,r_short,signal_sprd51swap);

signal_sprd710 = roll_signal(sprd710,sprd710,40,0.5); % 国债7-10，这个跟5-1和1510结合起来能提高一点点做多的胜率
[r_sprd710,alpha_sprd710] = long_short(r_long,r_short,signal_sprd710);

signal_AAA = roll_signal(sprdAAA,sprdAAA,40,0.5); % 信用利差，跟5-1和1510结合起来也能提高做多胜率
[r_AAA,alpha_AAA] = long_short(r_long,r_short,signal_AAA);

signal_swap = roll_signal(sprdswap,sprdswap,40,0.5); % SHIBOR利率互换与FR007利率互换利差,代表流动性溢价
[r_swap,alpha_swap] = long_short(r_long,r_short,signal_swap);

signal_curv = roll_signal(curv1510,curv1510,40,0.5);
[r_curv,alpha_curv] = long_short(r_long,r_short,signal_curv);

signal_curv_10d = roll_signal(curv1510_10d,curv1510,40,0.5);
[r_curv_10d,alpha_curv_10d] = long_short(r_long,r_short,signal_curv);

signal_curv2 = roll_signal(curv135,curv135,40,0.5);
[r_curv2,alpha_curv2] = long_short(r_long,r_short,signal_curv2);

signal_curv2_10d = roll_signal(curv135_10d,curv135,40,0.5);
[r_curv2_10d,alpha_curv2_10d] = long_short(r_long,r_short,signal_curv);

signal_curv3 = roll_signal(curv123,curv123,40,0.5);
[r_curv3,alpha_curv3] = long_short(r_long,r_short,signal_curv3);

signal_sprd3m = roll_signal(sprd51_3m,sprd51_3m,40,0.5);
signal_curv3m = roll_signal(curv1510_3m,curv1510_3m,40,0.5);
signal_fin3m = roll_signal(sprdfin_3m,sprdfin_3m,40,0.5);

signal_mom = mom1m>0;
[r_mom,alpha_mom] = long_short(r_long,r_short,signal_mom);

signal_mom3m = mom3m>0;
[r_mom3m,alpha_mom3m] = long_short(r_long,r_short,signal_mom3m);

signal_mom6m = mom6m<0; % 注意这里是反转，不是动量！
[r_mom6m,alpha_mom6m] = long_short(r_long,r_short,signal_mom6m);

signal_fin = roll_signal(sprdfin,sprdfin,40,0.5);
[r_fin,alpha_fin] = long_short(r_long,r_short,signal_fin);

signal_tax = roll_signal(taxfin,taxfin,40,0.5);
[r_tax,alpha_tax] = long_short(r_long,r_short,signal_tax);

signal_stk3m = stk3m < 0; 
[r_stk, alpha_stk] = long_short(r_long,r_short,signal_stk3m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%% 最终策略 %%%%%%%%%%%%%%%%%%%%
% 基准收益
r_base = r_short;

% 看空时换短债
r_sell = r_base;
signal_sell = (signal_curv==-1 & signal_curv_10d==-1 & signal_curv2==-1 & signal_curv2_10d==-1); % 为1时长债换仓成短债,或者从1~3换到货币
r_sell(signal_sell==1) = r_money(signal_sell==1);

r_found = r_base;
signal_found = (signal_curv==1 &  signal_sprd==1 & signal_curv_10d==1 & signal_sprd_10d==1);
r_found(signal_found==1) = r_long(signal_found==1);

r_reverse = r_base;
signal_reverse = (signal_found==1) & (signal_mom6m==1); % 曲线+反转策略
r_reverse(signal_reverse==1) = r_long(signal_reverse==1);

r_prev = r_base;
signal_prev = (signal_stk3m==1 & mom1m>0.00); % 追涨策略
r_prev(signal_prev==1) = r_long(signal_prev==1);

%%%%%%%%%% 备选做多策略 %%%%%%%%%%
r_found2 = r_base;  % 这个策略胜率75%左右, 7Y-10Y倒挂时相对收益更好
signal_found2 = (signal_found==1 & signal_sprd710==1); 
r_found2(signal_found2==1) = r_long(signal_found2==1);

r_found3 = r_base;  % 这个策略胜率在79%左右, AAA利差过高才做多
signal_found3 = (signal_found==1 & signal_AAA==1); 
r_found3(signal_found3==1) = r_long(signal_found3==1);

r_found4 = r_base;  % 这个策略胜率在87.5%左右,过高做多，不过信号少需要观察
signal_found4 = (signal_found==1 & signal_swap==1); 
r_found4(signal_found4==1) = r_long(signal_found4==1);

r_found5 = r_base; % 这个策略胜率在67.5%附近, 用国债5Y - IRS1Y代替国债期限利差作为信号
signal_found5 = (signal_sprd51swap==1 & signal_curv==1); % 国债5Y减IRS1Y
r_found5(signal_found5==1) = r_long(signal_found5==1);

r_found6 = r_base; % 这个策略胜率大于80%, 在基础策略的基础上加入国开隐含税率的因素, 但是信号很少
signal_found6 = (signal_found==1 & signal_tax==1);
r_found6(signal_found6==1) = r_long(signal_found6==1);

r_sell2 = r_base;  % 备选做空策略，AAA利差过低做空，这个策略的做空长债胜率在67.5%附近
signal_sell2 = (signal_sell==1 & signal_AAA==-1);
r_sell2(signal_sell2==1) = r_money(signal_sell2==1);

r_sell3 = r_base;
signal_sell3 = (signal_sell==1 & signal_swap==-1);
r_sell3(signal_sell3==1) = r_money(signal_sell3==1);

r_sell4 = r_base;
signal_sell4 = signal_sell==-1 & signal_curv3==-1;
r_sell4(signal_sell4==1) = r_money(signal_sell4==1);

r_prev2 = r_base;
signal_value = signal_value==1;
r_prev2(signal_value==1) = r_long(signal_value==1);

r_prev3 = r_base;
signal_comm = signal_comm==-1;
r_prev3(signal_comm==1) = r_money(signal_comm==1);

%%%%%%%%%% 备选做多策略 %%%%%%%%%%

% 用隐含税率作为赔率指标
% max = 1;
% active = ones(length(taxfin),1) * maaax;
% for i = 40:length(taxfin)
%     if taxfin(i) < median(taxfin(1:i))
%         active(i) = 0.5 * active(i);
%     end
% end

active = 0.6; % 主动长债仓位限制
signal = table(datestr(tbl.date,'yyyymmdd'),signal_found,signal_prev,signal_sell,signal_found2,signal_found3,signal_found4,signal_sell2,signal_sell3,signal_value,signal_comm);
signal.Properties.VariableNames{1} = 'times';
position = (signal_found) .* active * 1/3 + (signal_prev) .* active * 1/3 + (signal_reverse) .* active * 1/3;
r_all = r_sell .* (1-active) + r_found .* active * 1/3 + r_prev .* active * 1/3 + r_reverse .* active * 1/3 ;
%r_all = r_base .* (1-active) + r_found .* active * 1/3 + r_prev .* active * 1/3 + r_reverse .* active * 1/3 ;
alpha = r_all - r_base;
%%%%%%%%%%%%%%%%%%%% 最终策略 %%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%% 收益图表 %%%%%%%%%%%%%%%%%%%%

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
plot(tbl.date,nav(1:end-1),'r','LineWidth',2);
datetick('x','yyyy','keeplimits');
hold on;
plot(tbl.date,nav_short(1:end-1),'b');
plot(tbl.date,nav_long(1:end-1),'k');
legend('策略净值','中债1~3年国开财富指数','中债7~10年国开财富指数','Location','Best');
legend('boxoff');
title('策略净值曲线','FontSize',16);
axis tight;
hold off;
subplot(2,1,2);
plot(tbl.date,nav_mom(1:end-1),'b');
hold on;
plot(tbl.date,nav_sprd(1:end-1),'c');
plot(tbl.date,nav_curv(1:end-1),'m');
plot(tbl.date,nav_fin(1:end-1),'g');
plot(tbl.date,nav_stk(1:end-1),'k');
plot(tbl.date,nav_short(1:end-1),'r--','LineWidth',2);
datetick('x','yyyy','keeplimits');
legend('mom','sprd','curv','fin','stk','中债1~3年国开债指数','Location','Best');
title('单个因子策略净值曲线','FontSize',16);
axis tight;
legend();
legend('boxoff');
hold off;

figure(2);
yr = 2005:2020;
[alpha_yr,r_yr] = year_stats(alpha,r_all,tbl.date,yr);
friction = 0.0010; % 摩擦成本
costs = fees(position,friction);
[costs_yr,~] = year_stats(costs,costs,tbl.date,yr);
subplot(2,2,1);
bar(yr,alpha_yr*10000,'FaceColor',[0,0.5,0.5]);
ylabel('bps');
title('未扣费超额收益','FontSize',16);
axis tight;
subplot(2,2,2);
bar(yr,costs_yr,'FaceColor',[0,0.5,0.5]);
title(['摩擦费率',num2str(friction*10000),'bps交易成本'],'FontSize',16);
axis tight;
subplot(2,2,3);
bar(yr,alpha_yr-costs_yr,'FaceColor',[0,0.5,0.5]);
title('费后超额收益','FontSize',16);
axis tight;
subplot(2,2,4);
bar(yr,r_yr-costs_yr,'FaceColor',[0,0.5,0.5]);
title('费后绝对收益','FontSize',16);
axis tight;

figure(3);
plot(position);
title('长债仓位');

figure(4);
subplot(2,1,1);
costs_p = fees(signal_prev,friction); % 假设10bps/20bps的调仓双向交易成本
[costs_p_yr,~] = year_stats(costs_p,costs_p,tbl.date,yr);
bar(yr,costs_p_yr,'FaceColor',[0,0.5,0.5]);
title('动量策略交易成本','FontSize',16);
subplot(2,1,2);
costs_f = fees(signal_found,friction);% 假设10bps/20bps的调仓双向交易成本
[costs_f_yr,~] = year_stats(costs_f,costs_f,tbl.date,yr);
bar(yr,costs_f_yr,'FaceColor',[0,0.5,0.5]);
title('风险溢价交易成本','FontSize',16);
