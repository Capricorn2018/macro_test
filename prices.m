% CRB指数, CPI当月同比, PPI当月同比
[data,~,~,times,~,~]=w.edb('S0031505,M0000612,M0001227','2002-01-01','2019-07-15');

crb = data(:,1);
cpi = data(:,2);
ppi = data(:,3);

crb = log(crb);

for i = 1:length(crb)
    if(isnan(crb(i)))
        crb(i) = crb(i-1);
    end
end

bl = ~isnan(cpi) & ~isnan(ppi);

crb = crb(bl);
cpi = cpi(bl);
ppi = ppi(bl);
times = times(bl);

crb_diff = nan(length(crb),1);
crb_diff(12:end) = crb(12:end) - crb(1:end-11);
crb = crb_diff;

prices = table(times,crb,cpi,ppi);


