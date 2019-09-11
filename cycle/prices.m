% CRBָ��, CPI����ͬ��, PPI����ͬ��, 10Y��ծ������
[data,~,~,price_times,~,~]=w.edb('S0031505,M0000612,M0001227,S0059749','2002-01-01','2019-07-31');

crb = data(:,1);
cpi = data(:,2);%[NaN;data(1:end-1,2)]; % �ͺ�һ��
ppi = data(:,3);%[NaN;data(1:end-1,3)]; % �ͺ�һ��
bond = data(:,4);

crb = log(crb);

for i = 2:length(crb)
    if(isnan(crb(i)))
        crb(i) = crb(i-1); % ���nan
    end
    if(isnan(bond(i)))
        bond(i) = bond(i-1); % ���nan
    end
end

bl = ~isnan(cpi) & ~isnan(ppi);

crb = crb(bl);
cpi = cpi(bl);
ppi = ppi(bl);
bond = bond(bl);
price_times = price_times(bl);

cpi = [NaN;cpi(1:end-1)];
ppi = [NaN;ppi(1:end-1)];

crb_diff = nan(length(crb),1);
crb_diff(12:end) = crb(12:end) - crb(1:end-11);
crb = crb_diff;

inflation = table(price_times,crb,cpi,ppi,bond);


