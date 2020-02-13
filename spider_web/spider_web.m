function res = spider_web()

    w = windmatlab;

    % 读取所有的T合约列表
    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=T.CFE');
    
    % 合约列表中每个合约的起始和终止交易日
    frst_dt = datenum(contracts(:,7),'yyyy/mm/dd');
    last_dt = datenum(contracts(:,8),'yyyy/mm/dd');
    
    % 合约代码表
    cont_list = contracts(:,3);
    
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

