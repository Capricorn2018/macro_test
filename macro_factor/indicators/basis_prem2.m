function [res,times,cont_list] = basis_prem2(start_dt,end_dt)
% basis_prem国债期货基差历史
    
    w = windmatlab;

    % 读取所有的T合约列表
    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=T.CFE');
    
    % 合约列表中每个合约的起始和终止交易日
    frst_dt = datenum(contracts(:,7),'yyyy/mm/dd');
    last_dt = datenum(contracts(:,8),'yyyy/mm/dd');
    
    % 合约代码表
    cont_list = contracts(:,3);
    
    % 读取每个合约的每日CTD券
    cont_char = strjoin(contracts(:,3),',');    
    [ctd,~,~,ctd_times,~,~] = w.wsd(cont_char,'tbf_CTD',start_dt,end_dt,'exchangeType=NIB');
    
    % 取得所有曾经成为ctd的券表
    ctd_isch = cellfun(@ischar,ctd);
    bond_list = unique(ctd(ctd_isch));
    
    % 下面先读取每日的债券净价
    % 然后是每日的期货收盘价
    % 再然后是对应每个券和每个期货合约的转换因子(需要一个一个合约循环)
    % 最后按日循环, 每日先看当天的期货合约是哪三个, 然后读取转换因子、当日净价、和期货收盘价
    % 根据述三种数据算出当日对应的三个期货合约基差最小的券的基差, 作为当日基差
    [bond,~,~,bond_times,~,~] = w.wsd(bond_list,'net_cnbd',start_dt,end_dt,'credibility=1');
    [T,~,~,T_times,~,~] = w.wsd(cont_list,'close',start_dt,end_dt);
    
        
    for i=1:length(cont_list)
        [cf,~,~,cf_times,~,~]=w.wset('conversionfactor',['windcode=',cont_list{i}]);
        % 这里还需要注意跟原先的bond_list取交集之后做成一个matrix
    end
    
    % 按日循环
    for i = 1:length(ctd_times)
        % 这里先用active_cont来取每日活跃合约
        % 然后利用上面的cf和T以及bond来算当日的basis并且取最小的
    end
    
    w.close;
    
end

% 给定日期, 返回当日的当季、次季、远季合约序号, rk分别为1,2,3
function [rk,b] = active_cont(curr_dt,frst_dt,last_dt)
    
    b = frst_dt <= curr_dt & last_dt >= curr_dt;
    
    [~,I] = mink(last_dt(b),length(last_dt(b)));
    
    rk = b*1;
    
    rk(b) = I;

end


function plot_basis(times,last_dt,basis,cont_list,N)
    hold on
    M = max(1, length(last_dt) - N + 1);
    for i=M:length(last_dt)
        plot(times-last_dt(i),basis(:,i));
    end
    legend(cont_list(M:length(cont_list)));
    hold off
end


