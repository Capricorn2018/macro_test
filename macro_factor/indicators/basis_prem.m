function [basis,basis_time2mat,calender,dominant,dominant_basis,times,cont_list] = basis_prem(start_dt,end_dt)
% basis_prem国债期货基差历史
% calender是国债期货跨期价差历史
    
    w = windmatlab;

    % 读取所有的T合约列表
    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=TF.CFE');
    
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
    bond = nan(length(ctd_times),length(bond_list));
    T = nan(length(ctd_times),length(cont_list));
    
    [bond_wind,~,~,bond_times,~,~] = w.wsd(bond_list,'net_cnbd',start_dt,end_dt,'credibility=1');
    [T_wind,~,~,T_times,~,~] = w.wsd(cont_list,'close',start_dt,end_dt);
    [oi_wind,~,~,oi_times,~,~] = w.wsd(cont_list,'oi',start_dt,end_dt);
    [lt_wind,~,~,lt_times,~,~] = w.wsd(cont_list,'lasttrade_date',start_dt,end_dt);
    
    [C,ia,ib] = intersect(T_times,oi_times);
    T_wind = T_wind(ia,:);
    oi_wind = oi_wind(ib,:);
    
    [C,ia,ib] = intersect(C,lt_times);
    T_wind = T_wind(ia,:);
    oi_wind = oi_wind(ia,:);
    lt_wind = lt_wind(ib,:);
    T_times = C;
    % oi_times = C;
    
    
    % 先做时间对齐避免数据不统一
    [Lia,Locb] = ismember(bond_times,ctd_times);
    bond(Locb(Locb>0),:) = bond_wind(Lia,:);
    
    % 先做时间对齐避免数据不统一
    [Lia,Locb] = ismember(T_times,ctd_times);
    T(Locb(Locb>0),:) = T_wind(Lia,:);
    oi(Locb(Locb>0),:) = oi_wind(Lia,:);
    
    cf = nan(length(bond_list),length(cont_list));    
    for i=1:length(cont_list)
        [cf_i,~,~,~,~,~] = w.wset('conversionfactor',['windcode=',cont_list{i}]);
        % 这里还需要注意跟原先的bond_list取交集之后做成一个matrix
        [Lia,Locb] = ismember(cf_i(:,1),bond_list);
        cf(Locb(Locb>0),i) = cell2mat(cf_i(Lia,2));
    end
    
    
    basis = nan(length(ctd_times),length(cont_list));
    
    calender = nan(length(ctd_times),2);
    dominant = nan(length(ctd_times),1);
    dominant_basis = nan(length(ctd_times),1); % 主力合约年化基差
    
    % 按日循环
    for i = 1:length(ctd_times)
        % 这里先用active_cont来取每日活跃合约
        % 每日T合约编号, 当季:1, 次季:2, 远季:3
        curr_dt = ctd_times(i);
        [rk,~] = active_cont(curr_dt,frst_dt,last_dt);
        
        % 然后利用上面的cf和T以及bond来算当日的basis并且取最小的
        if any(rk==1)
            cf1 = cf(:,rk==1);
            basis1 = bond(i,:)' - cf1 .* T(i,rk==1);
            basis(i,rk==1) = min(basis1);
        end
        
        if any(rk==2)
            cf2 = cf(:,rk==2);
            basis2 = bond(i,:)' - cf2 .* T(i,rk==2);
            basis(i,rk==2) = min(basis2);   
        end
        
        if any(rk==3)
            cf3 = cf(:,rk==3);
            basis3 = bond(i,:)' - cf3 .* T(i,rk==3);
            basis(i,rk==3) = min(basis3);        
        end
        
        
        % 跨期价差
        if any(rk==1) && any(rk==2)
            calender(i,1) = T(i,rk==1) - T(i,rk==2);
            if oi(i,rk==1) >= oi(i,rk==2)
                dominant(i) = calender(i,1);
                dominant_basis(i) = basis(i,rk==1) * 63 / (datenum(lt_wind(i,rk==1)) - curr_dt);
            end
        end
        
        if any(rk==2) && any(rk==3)
            calender(i,2) = T(i,rk==2) - T(i,rk==3);
            if oi(i,rk==1) < oi(i,rk==2)
                dominant(i) = calender(i,2);
                dominant_basis(i) = basis(i,rk==2) * 63 / (datenum(lt_wind(i,rk==2)) - curr_dt);
            end
        end
        
    end
    
    times = ctd_times;
    
    plot_basis(times,last_dt,basis,cont_list,length(cont_list));
    
    idx = -300:0;
    basis_time2mat = nan(length(idx),length(cont_list));
    for i = 1:length(cont_list)
        [~,ia,ib] = intersect(times - last_dt(i),idx);
        basis_time2mat(ib,i) = basis(ia,i);
        basis_time2mat(1:max(ib),i) = fillmissing(basis_time2mat(1:max(ib),i),'previous');
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


