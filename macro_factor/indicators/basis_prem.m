function res = basis_prem(start_dt,end_dt)
% basis_prem国债期货基差历史
    
    w = windmatlab;

    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=T.CFE');
    
    frst_dt = datenum(contracts(:,7),'yyyy/mm/dd');
    last_dt = datenum(contracts(:,8),'yyyy/mm/dd');
    
    cont_list = contracts(:,3);
    
    cont_char = strjoin(contracts(:,3),',');    
    [ctd,~,~,ctd_times,~,~] = w.wsd(cont_char,'tbf_CTD',start_dt,end_dt,'exchangeType=NIB');
    
    % 取得所有曾经成为ctd的券表
    ctd_isch = cellfun(@ischar,ctd);
    bond_list = unique(ctd_isch);
    
    basis_1 = nan(length(ctd_times),length(bond_list));
    basis_2 = nan(length(ctd_times),length(bond_list));
    net_basis_1 = nan(length(ctd_times),length(bond_list));
    net_basis_2 = nan(length(ctd_times),length(bond_list));
    for i=1:length(bond_list)
        [data_1,~,~,~,~,~] =w.wsd(bond,'tbf_basis,tbf_netbasis',start_dt,end_dt,'contractType=NQ1');        
        [data_2,~,~,~,~,~] =w.wsd(bond,'tbf_basis,tbf_netbasis',start_dt,end_dt,'contractType=NQ2');
        basis_1(:,i) = data_1(:,1);
        basis_2(:,i) = data_2(:,1);
        net_basis_1(:,i) = data_1(:,2);
        net_basis_2(:,i) = data_2(:,2);
    end
    
    basis_1 = array2table(basis_1,'VariableNames',bond_list);
    basis_2 = array2table(basis_2,'VariableNames',bond_list);
    net_basis_1 = array2table(net_basis_1,'VariableNames',bond_list);
    net_basis_2 = array2table(net_basis_2,'VariableNames',bond_list);
    
    res = nan(length(ctd_times),length(cont_list));
    res = array2table(res,'VariableNames',cont_list);
        
    for i=1:length(ctd_times)
        curr_dt = ctd_times(i);
        [rk,b] = active_cont(curr_dt,frst_dt,last_dt);
        
        cont_1 = cont_list{rk==1};
        ctd_1 = ctd(i,cont_1);
        cont_2 = cont_list{rk==2};
        ctd_2 = ctd(i,cont_2);
        
        
        res(i,cont_1) =  basis_1(i,ctd_1);
        
    end

end

% 给定日期, 返回当日的当季、次季、远季合约序号, rk分别为1,2,3
function [rk,b] = active_cont(curr_dt,frst_dt,last_dt)
    
    b = frst_dt <= curr_dt & last_dt >= curr_dt;
    
    [~,I] = mink(last_dt(b),length(last_dt(b)));
    
    rk = b*1;
    
    rk(b) = I;

end
