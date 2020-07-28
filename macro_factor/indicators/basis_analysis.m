start_dt = '20130901';
end_dt = '20200723';

% [basis,calender,dominant,dominant_basis,times,cont_list] = basis_prem(start_dt,end_dt);

% [curve,yield] = term_prem(start_dt,end_dt);

x1 = curve.bond5y_bond1y;
x2 = yield.bond1y;
t = curve.times;

[C,ia,ib] = intersect(times,t);

x1 = x1(ib);
x2 = x2(ib);
y = dominant_basis(ia);

mdl = fitlm([x1,x2],y);

y_p = mdl.Fitted;

plot(C,y);
hold on;
plot(C,y_p);
datetick('x','yyyymm','keeplimits');
hold off;
