% CRB指数, CPI当月同比, PPI当月同比, 10Y国债收益率
[data,~,~,times,~,~]=w.edb('S0031505,M0000612,M0001227,S0059749','2002-01-01','2019-07-15');

crb = data(:,1);
cpi = [NaN;data(1:end-1,2)];
ppi = [NaN;data(1:end-1,3)];
bond = data(:,4);

crb = log(crb);

for i = 2:length(crb)
    if(isnan(crb(i)))
        crb(i) = crb(i-1);
    end
    if(isnan(bond(i)))
        bond(i) = bond(i-1);
    end
end

bl = ~isnan(cpi) & ~isnan(ppi);

crb = crb(bl);
cpi = cpi(bl);
ppi = ppi(bl);
bond = bond(bl);
times = times(bl);

crb_diff = nan(length(crb),1);
crb_diff(12:end) = crb(12:end) - crb(1:end-11);
crb = crb_diff;

inflation = table(times,crb,cpi,ppi,bond);


