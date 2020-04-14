start_dt = '1990-01-01';
end_dt = '2020-03-25';
file = 'D:/Projects/macro_test/data.mat';
[factors,assets] = wind_data(file,start_dt,end_dt);

reb = get_dates(file,5,'last');

reb(end) = datenum('2020-03-25'); % ����һ����ÿ���µ��������������
[~,ret] = load_assets(file,reb);

factor = load_factor(file,reb);
tbl = merge_xy(factor, ret);

% ��ȡ2005���Ժ����
tbl.mom1m = tbl.CBA02551 - tbl.CBA02521;
tbl.mom1m = [NaN;tbl.mom1m(1:end-1)];
tbl.mom2m = [NaN; movsum(tbl.mom1m,2,'Endpoints','discard')];
tbl.mom3m = [nan(2,1); movsum(tbl.mom1m,3,'Endpoints','discard')];
tbl.mom6m = [nan(5,1); movsum(tbl.mom1m,6,'Endpoints','discard')];

tbl.stk1m = [NaN;tbl.HS300(1:end-1)];
tbl.stk3m = [nan(2,1); movsum(tbl.stk1m,3,'Endpoints','discard')];

tbl.curv135_3m = [nan(2,1);movmean(tbl.mean_curv135,3,'Endpoints','discard')];
tbl.curv1510_3m = [nan(2,1);movmean(tbl.mean_curv1510,3,'Endpoints','discard')];
tbl.sprd31_3m = [nan(2,1);movmean(tbl.mean_sprd31,3,'Endpoints','discard')];
tbl.sprd51_3m = [nan(2,1);movmean(tbl.mean_sprd51,3,'Endpoints','discard')];
tbl.sprdfin_3m = [nan(2,1);movmean(tbl.mean_sprdfin,3,'Endpoints','discard')];
tbl.sprdliq_3m = [nan(2,1);movmean(tbl.mean_sprdliq,3,'Endpoints','discard')];

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

sprd31 = tbl.mean_sprd31;
sprd51 = tbl.mean_sprd51;
sprd51swap = tbl.mean_sprd51swap;
sprd710 = tbl.mean_sprd710;
sprdfin = tbl.mean_sprdfin;
sprdliq = tbl.mean_sprdliq;
sprdAAA = tbl.mean_sprdAAA;
taxfin = tbl.mean_taxfin;

% ���ʻ������¶�����,��������͵��,��ǰһ���µ�����
sprdswap = [NaN;tbl.sprdswap(1:end-1)];

curv135 = tbl.mean_curv135;
curv1510 = tbl.mean_curv1510;

sprd31_3m = tbl.sprd31_3m;
sprd51_3m = tbl.sprd51_3m;
curv135_3m = tbl.curv135_3m;
curv1510_3m = tbl.curv1510_3m;
sprdfin_3m = tbl.sprdfin_3m;
sprdliq_3m = tbl.sprdliq_3m;

% ��׼����
r_long = tbl.CBA02551_lag3d;
r_short = tbl.CBA02521_lag3d;
r_mid = tbl.CBA02531_lag3d;
r_money = tbl.CBA02511_lag3d;

signal_sprd = roll_signal(sprd51,40,0.5);
[r_sprd,alpha_sprd] = long_short(r_long,r_short,signal_sprd);

signal_sprd51swap = roll_signal(sprd51swap,40,0.5);
[r_sprd51swap,alpha_sprd51swap] = long_short(r_long,r_short,signal_sprd51swap);

signal_sprd710 = roll_signal(sprd710,40,0.5); % ��ծ7-10�������5-1��1510������������һ��������ʤ��
[r_sprd710,alpha_sprd710] = long_short(r_long,r_short,signal_sprd710);

signal_AAA = roll_signal(sprdAAA,40,0.5); % ���������5-1��1510�������Ҳ���������ʤ��
[r_AAA,alpha_AAA] = long_short(r_long,r_short,signal_AAA);

signal_swap = roll_signal(sprdswap,40,0.5); % SHIBOR���ʻ�����FR007���ʻ�������,�������������
[r_swap,alpha_swap] = long_short(r_long,r_short,signal_swap);

signal_curv = roll_signal(curv1510,40,0.5);
[r_curv,alpha_curv] = long_short(r_long,r_short,signal_curv);

signal_curv2 = roll_signal(curv135,40,0.5);
[r_curv2,alpha_curv2] = long_short(r_long,r_short,signal_curv2);

signal_sprd3m = roll_signal(sprd51_3m,40,0.5);
signal_curv3m = roll_signal(curv1510_3m,40,0.5);
signal_fin3m = roll_signal(sprdfin_3m,40,0.5);

signal_mom = mom1m>0;
[r_mom,alpha_mom] = long_short(r_long,r_short,signal_mom);

signal_mom3m = mom3m>0;
[r_mom3m,alpha_mom3m] = long_short(r_long,r_short,signal_mom3m);

signal_mom6m = mom6m<0; % ע�������Ƿ�ת�����Ƕ�����
[r_mom6m,alpha_mom6m] = long_short(r_long,r_short,signal_mom6m);

signal_fin = roll_signal(sprdfin,40,0.5);
[r_fin,alpha_fin] = long_short(r_long,r_short,signal_fin);

signal_tax = roll_signal(taxfin,40,0.5);
[r_tax,alpha_tax] = long_short(r_long,r_short,signal_tax);

signal_stk3m = stk3m < 0; 
[r_stk, alpha_stk] = long_short(r_long,r_short,signal_stk3m);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%% ���ղ��� %%%%%%%%%%%%%%%%%%%%
% ��׼����
r_base = r_short;

% ����ʱ����ծ
r_sell = r_base;
signal_sell = (signal_curv==-1 & signal_curv2==-1); % Ϊ1ʱ��ծ���ֳɶ�ծ,���ߴ�1~3��������
r_sell(signal_sell==1) = r_money(signal_sell==1);

r_found = r_base;
signal_found = (signal_curv==1 &  signal_sprd==1);
r_found(signal_found==1) = r_long(signal_found==1);

r_reverse = r_base;
signal_reverse = (signal_found==1) & (signal_mom6m==1); % ����+��ת����
r_reverse(signal_reverse==1) = r_long(signal_reverse==1);

r_prev = r_base;
signal_prev = (signal_stk3m==1 & signal_mom==1); % ׷�ǲ���
r_prev(signal_prev==1) = r_long(signal_prev==1);

%%%%%%%%%% ��ѡ������� %%%%%%%%%%
r_found2 = r_base;  % �������ʤ��75%����, 7Y-10Y����ʱ����������
signal_found2 = (signal_found==1 & signal_sprd710==1); 
r_found2(signal_found2==1) = r_long(signal_found2==1);

r_found3 = r_base;  % �������ʤ����79%����, AAA������߲�����
signal_found3 = (signal_found==1 & signal_AAA==1); 
r_found3(signal_found3==1) = r_long(signal_found3==1);

r_found4 = r_base;  % �������ʤ����87.5%����,swap1Y-bond1Y�������࣬�����ź�����Ҫ�۲�
signal_found4 = (signal_found==1 & signal_swap==1); 
r_found4(signal_found4==1) = r_long(signal_found4==1);

r_found5 = r_base; % �������ʤ����67.5%����, �ù�ծ5Y - IRS1Y�����ծ����������Ϊ�ź�
signal_found5 = (signal_sprd51swap==1 & signal_curv==1); % ��ծ5Y��IRS1Y
r_found5(signal_found5==1) = r_long(signal_found5==1);

r_found6 = r_base; % �������ʤ�ʴ���80%, �ڻ������ԵĻ����ϼ����������˰�ʵ�����, �����źź���
signal_found6 = (signal_found==1 & signal_tax==1);
r_found6(signal_found6==1) = r_long(signal_found6==1);

r_sell2 = r_base;  % ��ѡ���ղ��ԣ�AAA����������գ�������Ե����ճ�ծʤ����67.5%����
signal_sell2 = (signal_sell==1 & signal_AAA==-1);
r_sell2(signal_sell2==1) = r_money(signal_sell2==1);
%%%%%%%%%% ��ѡ������� %%%%%%%%%%

% ������˰����Ϊ����ָ��
% max = 1;
% active = ones(length(taxfin),1) * max;
% for i = 40:length(taxfin)
%     if taxfin(i) < median(taxfin(1:i))
%         active(i) = 0.5 * active(i);
%     end
% end

active = 0.6; % ������ծ��λ����
signal = table(datestr(tbl.date,'yyyymmdd'),signal_found,signal_prev,signal_sell,signal_found2,signal_found3,signal_found4,signal_sell2);
position = (signal_found) .* active * 1/3 + (signal_prev) .* active * 1/3 + (signal_reverse) .* active * 1/3;
%r_all = r_sell .* (1-active) + r_found .* active * 1/3 + r_prev .* active * 1/3 + r_reverse .* active * 1/3 ;
r_all = r_base .* (1-active) + r_found .* active * 1/3 + r_prev .* active * 1/3 + r_reverse .* active * 1/3 ;
alpha = r_all - r_base;
%%%%%%%%%%%%%%%%%%%% ���ղ��� %%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%% ����ͼ�� %%%%%%%%%%%%%%%%%%%%

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
legend('���Ծ�ֵ','��ծ1~3������Ƹ�ָ��','��ծ7~10������Ƹ�ָ��','Location','Best');
legend('boxoff');
title('���Ծ�ֵ����','FontSize',16);
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
legend('mom','sprd','curv','fin','stk','��ծ1~3�����ծָ��','Location','Best');
title('�������Ӳ��Ծ�ֵ����','FontSize',16);
axis tight;
legend();
legend('boxoff');
hold off;

figure(2);
yr = 2005:2020;
[alpha_yr,r_yr] = year_stats(alpha,r_all,tbl.date,yr);
friction = 0.0010; % Ħ���ɱ�
costs = fees(position,friction);
[costs_yr,~] = year_stats(costs,costs,tbl.date,yr);
subplot(2,2,1);
bar(yr,alpha_yr*10000,'FaceColor',[0,0.5,0.5]);
ylabel('bps');
title('δ�۷ѳ�������','FontSize',16);
axis tight;
subplot(2,2,2);
bar(yr,costs_yr,'FaceColor',[0,0.5,0.5]);
title(['Ħ������',num2str(friction*10000),'bps���׳ɱ�'],'FontSize',16);
axis tight;
subplot(2,2,3);
bar(yr,alpha_yr-costs_yr,'FaceColor',[0,0.5,0.5]);
title('�Ѻ󳬶�����','FontSize',16);
axis tight;
subplot(2,2,4);
bar(yr,r_yr-costs_yr,'FaceColor',[0,0.5,0.5]);
title('�Ѻ��������','FontSize',16);
axis tight;

figure(3);
plot(position);
title('��ծ��λ');

figure(4);
subplot(2,1,1);
costs_p = fees(signal_prev,friction); % ����10bps/20bps�ĵ���˫���׳ɱ�
[costs_p_yr,~] = year_stats(costs_p,costs_p,tbl.date,yr);
bar(yr,costs_p_yr,'FaceColor',[0,0.5,0.5]);
title('�������Խ��׳ɱ�','FontSize',16);
subplot(2,1,2);
costs_f = fees(signal_found,friction);% ����10bps/20bps�ĵ���˫���׳ɱ�
[costs_f_yr,~] = year_stats(costs_f,costs_f,tbl.date,yr);
bar(yr,costs_f_yr,'FaceColor',[0,0.5,0.5]);
title('������۽��׳ɱ�','FontSize',16);
