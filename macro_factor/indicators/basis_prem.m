function [res,times,cont_list] = basis_prem(start_dt,end_dt)
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
    
    % 初始化当季、次季、远季基差和净基差
    basis_1 = nan(length(ctd_times),length(bond_list));
    basis_2 = nan(length(ctd_times),length(bond_list));
    basis_3 = nan(length(ctd_times),length(bond_list));
    net_basis_1 = nan(length(ctd_times),length(bond_list));
    net_basis_2 = nan(length(ctd_times),length(bond_list));
    net_basis_3 = nan(length(ctd_times),length(bond_list));
    
    % 循环从Wind API读取每个券的当季、次季、远季基差
    for i=1:length(bond_list)
        
        bond = bond_list{i};
        
        [data_1,~,~,times_1,~,~] =w.wsd(bond,'tbf_basis,tbf_netbasis',start_dt,end_dt,'contractType=NQ1');        
        [data_2,~,~,times_2,~,~] =w.wsd(bond,'tbf_basis,tbf_netbasis',start_dt,end_dt,'contractType=NQ2');
        [data_3,~,~,times_3,~,~] =w.wsd(bond,'tbf_basis,tbf_netbasis',start_dt,end_dt,'contractType=NQ3');
        
        if iscell(data_1)
            data_1 = cell2mat(data_1);
            data_2 = cell2mat(data_2);
            data_3 = cell2mat(data_3);
        end
        
        [Lia_1,Locb_1] = ismember(times_1,ctd_times);
        [Lia_2,Locb_2] = ismember(times_2,ctd_times);
        [Lia_3,Locb_3] = ismember(times_3,ctd_times);
        
        basis_1(Locb_1,i) = data_1(Lia_1,1);
        basis_2(Locb_2,i) = data_2(Lia_2,1);
        basis_3(Locb_3,i) = data_3(Lia_3,1);
        net_basis_1(Locb_1,i) = data_1(Lia_1,2);
        net_basis_2(Locb_2,i) = data_2(Lia_2,2);
        net_basis_3(Locb_3,i) = data_3(Lia_3,2);
        
    end
        
    % 初始化结果
    res = nan(length(ctd_times),length(cont_list));
        
    % 将基差矩阵中的结果与当季、次季、远季基差矩阵中的结果匹配
    for i=1:length(ctd_times)
        
        % 每日T合约编号, 当季-1, 次季-2, 远季-3
        curr_dt = ctd_times(i);
        [rk,~] = active_cont(curr_dt,frst_dt,last_dt);
        
        ctd_1 = NaN;
        ctd_2 = NaN;
        ctd_3 = NaN;
        
        % 当季合约的当日CTD券代码
        cont_1 = rk==1;
        if any(cont_1)
            ctd_1 = ctd{i,cont_1};
        end

        % 次季合约的当日CTDF券代码
        cont_2 = rk==2;
        if any(cont_2)
            ctd_2 = ctd{i,cont_2};
        end
        
        % 远季合约的当日CTD券代码
        cont_3 = rk==3;
        if any(cont_3)
            ctd_3 = ctd{i,cont_3};
        end
        
        % 从当季基差里面读取当日当季CTD的基差
        if ischar(ctd_1)            
            [~,Locb] = ismember(ctd_1,bond_list);
            res(i,cont_1) = basis_1(i,Locb);
        end
        
        % 从次季基差里面读取当日次季CTD的基差
        if ischar(ctd_2)            
            [~,Locb] = ismember(ctd_2,bond_list);
            res(i,cont_2) = basis_2(i,Locb);
        end
        
        % 从远季基差里面读取当日远季CTD的基差
        if ischar(ctd_3)            
            [~,Locb] = ismember(ctd_3,bond_list);
            res(i,cont_3) = basis_3(i,Locb);
        end
        
    end

    times = ctd_times;
    
    plot_basis(times,last_dt,res,cont_list,length(cont_list));
    
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
