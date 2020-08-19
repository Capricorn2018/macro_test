main;

nav = xlsread('C:\Users\zhouxy\Desktop\日常办公\信用债筛选项目\结果和问题\index_nv.csv');
nav = nav(:,2:end);

t_reb = datenum(signal.times,'yyyymmdd');

t_nav = nav(:,1);
t_nav = datenum(num2str(t_nav),'yyyymmdd');

[Lia,Locb] = ismember(t_reb,t_nav);

Locb = Locb(Lia);

hedge_signal = nan(length(t_nav),1);
hedge_signal(Locb) = max(signal.signal_sell(Lia) - signal.signal_prev(Lia),0);
hedge_signal = fillmissing(hedge_signal,'previous');

long_signal = nan(length(t_nav),1);
long_signal(Locb) = signal.signal_found(Lia);
long_signal = fillmissing(long_signal,'previous');

for i=1:length(Locb)
    if(Locb(i)~=1 && Locb(i)~=length(t_nav))        
        hedge_signal(Locb(i)) = hedge_signal(Locb(i)-1);
        hedge_signal(Locb(i)+1) = hedge_signal(Locb(i)); % 信号发出第二天收盘才能进
        long_signal(Locb(i)) = long_signal(Locb(i)-1);
        long_signal(Locb(i)+1) = long_signal(Locb(i));
    else
        if(Locb==1)
            hedge_signal(1) = 0;
            hedge_signal(2) = 0;
            long_signal(1) = 0;
            long_signal(2) = 0;
        else
            hedge_signal(Locb(i)) = hedge_signal(Locb(i)-1);
            long_signal(Locb(i)) = long_signal(Locb(i)-1);
        end
    end
end

before = signal(t_reb <= t_nav(1),:);
frst_signal = max(before.signal_sell(end) - before.signal_prev(end),0);
hedge_signal(isnan(hedge_signal)) = frst_signal; 
frst_signal = before.signal_found(end);
long_signal(isnan(long_signal)) = frst_signal;


start_dt = datestr(t_nav(1),'yyyymmdd');
end_dt = datestr(t_nav(end),'yyyymmdd');

[times,pct_main,dv01_main] = futures(start_dt,end_dt);

[C,ia,ib] = intersect(times,t_nav);

t = C;
nav_data = nav(ib,2);
hedge_signal = hedge_signal(ib);
long_signal = long_signal(ib);
pct_main = pct_main(ia);
dv01_main = dv01_main(ia);

ratio = 0.5;
nav_pct = [0;nav_data(2:end)./nav_data(1:end-1)-1];

hedge_pct = hedge_signal .* pct_main/100 .* ratio;

pos = 0.4;
long_pct = long_signal .* pct_main/100 .* pos;

rtn = nav_pct - hedge_pct + long_pct;

result = cumprod(1+rtn,'omitnan');