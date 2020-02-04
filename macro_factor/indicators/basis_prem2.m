function [res,times,cont_list] = basis_prem2(start_dt,end_dt)
% basis_prem��ծ�ڻ�������ʷ
    
    w = windmatlab;

    % ��ȡ���е�T��Լ�б�
    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=T.CFE');
    
    % ��Լ�б���ÿ����Լ����ʼ����ֹ������
    frst_dt = datenum(contracts(:,7),'yyyy/mm/dd');
    last_dt = datenum(contracts(:,8),'yyyy/mm/dd');
    
    % ��Լ�����
    cont_list = contracts(:,3);
    
    % ��ȡÿ����Լ��ÿ��CTDȯ
    cont_char = strjoin(contracts(:,3),',');    
    [ctd,~,~,ctd_times,~,~] = w.wsd(cont_char,'tbf_CTD',start_dt,end_dt,'exchangeType=NIB');
    
    % ȡ������������Ϊctd��ȯ��
    ctd_isch = cellfun(@ischar,ctd);
    bond_list = unique(ctd(ctd_isch));
    
    % �����ȶ�ȡÿ�յ�ծȯ����
    % Ȼ����ÿ�յ��ڻ����̼�
    % ��Ȼ���Ƕ�Ӧÿ��ȯ��ÿ���ڻ���Լ��ת������(��Ҫһ��һ����Լѭ��)
    % �����ѭ��, ÿ���ȿ�������ڻ���Լ��������, Ȼ���ȡת�����ӡ����վ��ۡ����ڻ����̼�
    % ��������������������ն�Ӧ�������ڻ���Լ������С��ȯ�Ļ���, ��Ϊ���ջ���
    [bond,~,~,bond_times,~,~] = w.wsd(bond_list,'net_cnbd',start_dt,end_dt,'credibility=1');
    [T,~,~,T_times,~,~] = w.wsd(cont_list,'close',start_dt,end_dt);
    
        
    for i=1:length(cont_list)
        [cf,~,~,cf_times,~,~]=w.wset('conversionfactor',['windcode=',cont_list{i}]);
        % ���ﻹ��Ҫע���ԭ�ȵ�bond_listȡ����֮������һ��matrix
    end
    
    % ����ѭ��
    for i = 1:length(ctd_times)
        % ��������active_cont��ȡÿ�ջ�Ծ��Լ
        % Ȼ�����������cf��T�Լ�bond���㵱�յ�basis����ȡ��С��
    end
    
    w.close;
    
end

% ��������, ���ص��յĵ������μ���Զ����Լ���, rk�ֱ�Ϊ1,2,3
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


