function [basis,calender,dominant,dominant_basis,times,cont_list] = basis_prem(start_dt,end_dt)
% basis_prem��ծ�ڻ�������ʷ
% calender�ǹ�ծ�ڻ����ڼ۲���ʷ
    
    w = windmatlab;

    % ��ȡ���е�T��Լ�б�
    [contracts,~,~,~,~,~] = w.wset('futurecc','wind_code=TF.CFE');
    
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
    bond = nan(length(ctd_times),length(bond_list));
    T = nan(length(ctd_times),length(cont_list));
    
    [bond_wind,~,~,bond_times,~,~] = w.wsd(bond_list,'net_cnbd',start_dt,end_dt,'credibility=1');
    [T_wind,~,~,T_times,~,~] = w.wsd(cont_list,'close',start_dt,end_dt);
    [oi_wind,~,~,oi_times,~,~] = w.wsd(cont_list,'oi',start_dt,end_dt);
    [lt_wind,~,~,lt_times,~,~] = w.wsd(cont_list,'lasttrade_date',start_dt,end_dt);
    
    [C,ia,ib] = intersect(T_times,oi_times);
    T_wind = T_wind(ia,:);
    oi_wind = oi_wind(ib,:);
    T_times = C;
    
    [C,ia,ib] = intersect(C,lt_times);
    T_wind = T_wind(ia,:);
    oi_wind = oi_wind(ia,:);
    lt_wind = lt_wind(ib,:);
    T_times = C;
    % oi_times = C;
    
    
    % ����ʱ�����������ݲ�ͳһ
    [Lia,Locb] = ismember(bond_times,ctd_times);
    bond(Locb(Locb>0),:) = bond_wind(Lia,:);
    
    % ����ʱ�����������ݲ�ͳһ
    [Lia,Locb] = ismember(T_times,ctd_times);
    T(Locb(Locb>0),:) = T_wind(Lia,:);
    oi(Locb(Locb>0),:) = oi_wind(Lia,:);
    
    cf = nan(length(bond_list),length(cont_list));    
    for i=1:length(cont_list)
        [cf_i,~,~,~,~,~] = w.wset('conversionfactor',['windcode=',cont_list{i}]);
        % ���ﻹ��Ҫע���ԭ�ȵ�bond_listȡ����֮������һ��matrix
        [Lia,Locb] = ismember(cf_i(:,1),bond_list);
        cf(Locb(Locb>0),i) = cell2mat(cf_i(Lia,2));
    end
    
    
    basis = nan(length(ctd_times),length(cont_list));
    
    calender = nan(length(ctd_times),2);
    dominant = nan(length(ctd_times),1);
    dominant_basis = nan(length(ctd_times),1); % ������Լ�껯����
    
    % ����ѭ��
    for i = 1:length(ctd_times)
        % ��������active_cont��ȡÿ�ջ�Ծ��Լ
        % ÿ��T��Լ���, ����:1, �μ�:2, Զ��:3
        curr_dt = ctd_times(i);
        [rk,~] = active_cont(curr_dt,frst_dt,last_dt);
        
        % Ȼ�����������cf��T�Լ�bond���㵱�յ�basis����ȡ��С��
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
        
        
        % ���ڼ۲�
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


