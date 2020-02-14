function [nav,times,signal,open,close] = spider_web()

    [signal,times] = sw_signal();
    
    start_dt = datestr(times(1),'yyyy-mm-dd');
    end_dt = datestr(times(end),'yyyy-mm-dd');

    w = windmatlab;

    % 读取所有的T合约列表
    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=T.CFE');
    
    % 合约列表中每个合约的起始和终止交易日
    frst_dt = datenum(contracts(:,7),'yyyy/mm/dd');
    last_dt = datenum(contracts(:,8),'yyyy/mm/dd');
    
    % 合约代码表
    cont_list = contracts(:,3);
    
    oi = nan(length(times),length(cont_list));
    open = nan(length(times),length(cont_list));
    close = nan(length(times),length(cont_list));
    
    for i=1:length(cont_list)
        
        [T,~,~,Ttimes,~,~] = w.wsd(cont_list{i},'oi,open,close',start_dt,end_dt);
        [Lia,Locb] = ismember(Ttimes,times);
        oi(Locb(Locb>0),i) = T(Lia,1);
        open(Locb(Locb>0),i) = T(Lia,2);
        close(Locb(Locb>0),i) = T(Lia,3);
        
    end
    
    nav = ones(length(times),1);
    
    for j=2:length(times)
        
        [~,k] = max(oi(j,:));
        if ~isnan(signal)
            r = (close(j,k) - open(j,k)) * signal(j) / 100;
        else
            r = 0.;
        end
        
        nav(j) = nav(j-1) * (1+r);
        
    end
    
    w.close;

end

function [signal,times] = sw_signal()
% sw_signal, 生成蜘蛛网格信号
    T = readtable('T.csv');
    B = T(T.fs_info_type==2,:);
    S = T(T.fs_info_type==3,:);
    
    Btimes = B.trade_dt;
    Stimes = S.trade_dt;
    
    if any(Btimes~=Stimes)
        disp('Error: buy and sell contracts data trading dates are not identical!');
    end
    
    trade_dt = Btimes;
    
    signal = zeros(height(B),1);
    
    for i = 2:(height(B)-1)
        
        dB = B.positions(i) - B.positions(i-1);
        dS = S.positions(i) - S.positions(i-1);
        
        if dB>0 && dS<0 && trade_dt(i)-trade_dt(i+1)==-1            
            signal(i+1) = 1;            
        else
            if dB<0 && dS>0 && trade_dt(i)-trade_dt(i+1)==-1    
                signal(i+1) = -1;
            end
        end
        
    end
    
    times = datenum(num2str(trade_dt),'yyyymmdd');
    
end

