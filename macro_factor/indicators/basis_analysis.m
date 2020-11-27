start_dt = '20130901';
end_dt = '20201126';

[basis,basis_time2mat,calender,dominant,dominant_basis,times,cont_list] = basis_prem(start_dt,end_dt);

[curve,yield] = term_prem(start_dt,end_dt);

x1 = curve.bond5y_bond1y;
x2 = yield.bond1y;
t = curve.times;

[C,ia,ib] = intersect(times,t);

x1 = x1(ib);
x2 = x2(ib);
y = dominant_basis(ia);

y2 = dominant(ia);

mdl = fitlm([x1,x2],y);

y_p = mdl.Fitted;

figure(10);
plot(C,y);
hold on;
plot(C,y_p);
plot(C,y2);
datetick('x','yyyymm','keeplimits');
legend('basis','pred_basis','calender');
hold off;
axis tight;
