start_dt = '20130901';
end_dt = '20201113';

credit = credit_prem(start_dt,end_dt);
[liq, rate] = liq_prem(start_dt,end_dt);

x = liq.shi3ms1y_irs1y;
y = credit.aaa3y_bond3y;

mdl = fitlm(x,y);

t = liq.times;
figure(10);
plot(t,mdl.Residuals.Raw);
datetick('x','yyyymm','keeplimits');
axis tight;