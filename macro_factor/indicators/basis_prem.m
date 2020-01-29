function res = basis_prem(start_dt,end_dt)
% basis_prem��ծ�ڻ�������ʷ
    
    w = windmatlab;

    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=T.CFE');
    
    frst_dt = datenum(contracts(:,7),'yyyy/mm/dd');
    last_dt = datenum(contracts(:,8),'yyyy/mm/dd');

    cont_list = strjoin(contracts(:,3),',');
    [ctd,~,~,ctd_times,~,~] = w.wsd(cont_list,'tbf_CTD',start_dt,end_dt,'exchangeType=NIB');
    
    bond_list = unique(ctd);
        
    for i=1:length(ctd_times)
        curr_dt = ctd_times(i);
        [rk,b] = active_cont(curr_dt,frst_dt,last_dt);
        
    end

end

% ��������, ���ص��յĵ������μ���Զ����Լ���, rk�ֱ�Ϊ1,2,3
function [rk,b] = active_cont(curr_dt,frst_dt,last_dt)
    
    b = frst_dt <= curr_dt & last_dt >= curr_dt;
    
    [~,I] = mink(last_dt(b),length(last_dt(b)));
    
    rk = b*1;
    
    rk(b) = I;

end
