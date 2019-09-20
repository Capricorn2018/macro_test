start_dt = '20050101';
end_dt = '20190801';

w = windmatlab;
%  股票和南华工业品指数
[stk_data,stk_codes,~,stk_times,~,~] = w.wsd('000300.SH,000905.SH,HSI.HI,NH0200.NHF',...
                                                'close',start_dt,end_dt);
% 预测平均值：CPI当月同比, 预测平均值：PPI当月同比, GDP现价累计同比, 预测平均值：GDP同比（年）, 70成新建住宅价格指数
[growth_data,growth_codes,~,growth_times,~,~] = w.edb('M0061676,M0061677,M0001395,M0329172,S2707403',...
                                                        start_dt,end_dt,'Fill=Previous');
                                                
 
x = growth_data(:,3);
ngdp = nan(length(x),1);

for i=2:length(x)
    if x(i-1)~=x(i)
        ngdp(i-1) = x(i)/x(i-1) - 1;
    end
end

for i = (length(ngdp)-1):-1:1
    if isnan(ngdp(i))
        ngdp(i) = ngdp(i+1);
    end
end

fgdp = growth_data(:,4);
fcpi = growth_data(:,1);
fppi = growth_data(:,2);
diff = ngdp - fgdp - fcpi*0.7 - fppi*0.3;


house = growth_data(:,5);

idx = match_times(stk_times,growth_times);

stk = nan(length(idx),size(stk_data,2));
stk(~isnan(idx),:) = stk_data(idx(~isnan(idx)),:);
rtn = stk(2:end,:)./stk(1:end-1,:) - 1;
rtn = [nan(1,size(rtn,2));rtn];

rtn = [rtn,house];
