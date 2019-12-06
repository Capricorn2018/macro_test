% 利率互换FR007:1Y, 利率互换3M SHIBOR:1Y, 中国国债10Y, 美国国债10Y, 美国TIPS10Y
% 日本国债10Y, 德国国债10Y, 英国国债10Y, 中票AAA 5Y, 中国国债5Y 
[data,codes,~,times,~,~] = w.edb(['M0048486,M0048499,S0059749,G0000891,G0005428,',...
                                    'G1235664,G0008068,G0006353,S0059739,S0059747'],...
                                    '2009-01-01','2019-12-03');4
[data_fill,~,~,~,~,~] = w.edb(['M0048486,M0048499,S0059749,G0000891,G0005428,',...
                                    'G1235664,G0008068,G0006353,S0059739,S0059747'],...
                                    '2009-01-01','2019-12-03',...
                                    'Fill=Previous');
                                
last_day = times(end);

last1m = datemnth(last_day,-1,0,0,0);
last3m = datemnth(last_day,-3,0,0,0);
last6m = datemnth(last_day,-6,0,0,0);
last1y = datemnth(last_day,-12,0,0,0);
last10y = datemnth(last_day,-120,0,0,0);

yr_st = datenum(year(last_day),1,);

data_fill(:,9) = data_fill(:,2) - data_fill(:,1);
data_fill(:,10) = data_fill(:,9) - data_fill(:,10);

p1m = data_fill(times>=max(times(times<=last1m)),:);
p3m = data_fill(times>=max(times(times<=last3m)),:);
p6m = data_fill(times>=max(times(times<=last6m)),:);
p1y = data_fill(times>=max(times(times<=last1y)),:);
pytd = data_fill(times>=max(times(times<=yr_st)),:);

diff1m = p1m(end,:) - p1m(1,:);
diff3m = p3m(end,:) - p3m(1,:);
diff6m = p6m(end,:) - p6m(1,:);
diff1y = p1y(end,:) - p1y(1,:);
diffytd = pytd(end,:) - pytd(1,:);

p10y = data(times>=max(times(times<=last10y)),:);

z = nan(10,1);

liq_rp = p10y(:,2) - p10y(:,1); x = find_last(liq_rp) ; z(9) = (x-mean(liq_rp,'omitnan'))/std(liq_rp,'omitnan');
aaa_rp = p10y(:,9) - p10y(:,10); x = find_last(aaa_rp) ; z(10) = (x-mean(aaa_rp,'omitnan'))/std(aaa_rp,'omitnan');

irs7d = p10y(:,1); x = find_last(irs7d); z(1) = (x-mean(irs7d,'omitnan'))/std(irs7d,'omitnan');
irs3m = p10y(:,2);x = find_last(irs3m); z(2) = (x-mean(irs3m,'omitnan'))/std(irs3m,'omitnan');
china10y = p10y(:,3); x = find_last(china10y); z(3) = (x-mean(china10y,'omitnan'))/std(china10y,'omitnan');
us10y = p10y(:,4); x = find_last(us10y); z(4) = (x-mean(us10y,'omitnan'))/std(us10y,'omitnan');
tips10y = p10y(:,5); x = find_last(tips10y); z(5) = (x-mean(tips10y,'omitnan'))/std(tips10y,'omitnan');
jap10y = p10y(:,6); x = find_last(jap10y); z(6) = (x-mean(jap10y,'omitnan'))/std(jap10y,'omitnan');
ger10y = p10y(:,7); x = find_last(ger10y); z(7) = (x-mean(ger10y,'omitnan'))/std(ger10y,'omitnan');
bri10y = p10y(:,8); x = find_last(bri10y); z(8) = (x-mean(bri10y,'omitnan'))/std(bri10y,'omitnan');

result = nan(10,6);
result(:,1) = diff1m';
result(:,2) = diff3m';
result(:,3) = diff6m';
result(:,4) = diff1y';
result(:,5) = diffytd';
result(:,6) = z;



