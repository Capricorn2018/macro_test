clear;clc;
load('D:\Projects\Chinarisk\data\input\macro\M1004271.mat', 'x')
load('D:\Projects\Chinarisk\data\input\CSI100.mat')

y = outerjoin(m,x,'Type','left','MergeKeys',true);
y.VALUE =adj_table(y.VALUE);
y.yield_diff = [0;y.VALUE(2:end)-y.VALUE(1:end-1)];

[y.corr1,y.corr] = deal(zeros(height(y),1));

for i = 250: height(y)
    y.corr(i) = corr(y.yield_diff(i-249:i),-y.RTN_V(i-249:i)) ;
end

% for i = 30: height(y)
%     y.corr(i) = mean(y.corr1(i-29:i)); 
% end

% load('D:\Projects\Chinarisk\data\input\macro\M0000612.mat')
% x1 = x; x1.Properties.VariableNames(end) = {'CPI'};
% load('D:\Projects\Chinarisk\data\input\macro\M0001227.mat')
% x.Properties.VariableNames(end) = {'PPI'};
% z  = outerjoin(x1,x,'Type','left','MergeKeys',true);
% z.inflatio = (z.CPI+z.PPI)/2;
% 
% C = outerjoin(y,z,'MergeKeys',true);
% C = sortrows(C,{'DATEN'},{'ascend'});
% C(isnan(C.corr),:) = [];
% C(C.corr==0,:) = [];
% C.inflatio = adj_table(C.inflatio);

% plot(C.DATEN,C.corr); hold on ;
% plot(C.DATEN,zeros(height(C),1));
% yyaxis right
% plot(C.DATEN,C.inflatio);
% datetick('x','yy','keeplimits')
% xlim([C.DATEN(1),C.DATEN(end)])
% legend('股债相关性','广义通胀')
% legend('boxoff')

%%
load('D:\Projects\Chinarisk\data\input\CU.mat')
m.Properties.VariableNames = {'DATEN','CU_RTNV','CU_RTNP'};
y = outerjoin(y,m,'Type','left','MergeKeys',true);
y(isnan(y.CU_RTNP),:) = [];
[y.corr_cu_bond] = deal(zeros(height(y),1));
for i = 250: height(y)
    y.corr_cu_bond(i) = corr(y.yield_diff(i-249:i),-y.CU_RTNV(i-249:i)) ;
end

y(y.corr_cu_bond==0,:) = [];
%%
plot(y.DATEN,y.corr);hold on;
plot(y.DATEN,zeros(height(y),1));hold on;
yyaxis right
plot(y.DATEN,y.VALUE);
datetick('x','yy','keeplimits')
xlim([y.DATEN(1),y.DATEN(end)])
legend('股债相关性','十年国开')
legend('boxoff')
%%
plot(y.DATEN,y.corr_cu_bond);hold on;
plot(y.DATEN,zeros(height(y),1));hold on;
yyaxis right
plot(y.DATEN,y.VALUE);
datetick('x','yy','keeplimits')
xlim([y.DATEN(1),y.DATEN(end)])
legend('铜债相关性','十年国开')
legend('boxoff')