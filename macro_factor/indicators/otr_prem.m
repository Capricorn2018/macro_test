function [sprd21,sprd31,sprd32,times] =  otr_prem(start_dt,end_dt)
% otm_preme���������10������ȯ����
    w = windmatlab;
    
    % ��otr_prem.xlsx�ж���ȯ������ȯ��Ҫ�ֶ������ļ�
    [~,bond_list,~] = xlsread('inputs/otr_prem.xlsx','bond_list');
    bond_list = strjoin(bond_list,',');
    
    [mat,~,~,mat_times,~,~] = w.wsd(bond_list,'matu_cnbd',start_dt,end_dt,'credibility=1');
    
    [yield,~,~,yield_times,~,~] = w.wsd(bond_list,'yield_cnbd',start_dt,end_dt,'credibility=1');
    
    [times,ia,ib] = intersect(mat_times,yield_times);
    mat = mat(ia,:);
    yield = yield(ib,:);
    
    sprd31 = nan(size(yield,1),1);
    sprd21 = nan(size(yield,1),1);
    sprd32 = nan(size(yield,1),1);
    
    for i=1:size(mat,1)
        mati = mat(i,:);
        [~,I] = maxk(mati,3);
        yieldi = yield(i,I);
        sprd31(i) = yieldi(3) - yieldi(1);
        sprd21(i) = yieldi(2) - yieldi(1);
        sprd32(i) = yieldi(3) - yieldi(2);
        
    end
    
    subplot(3,2,1);
    plot_hist(sprd21);
    title('��������ȯ����ȯ����ֲ�ͼ');
    subplot(3,2,2);
    plot(times,sprd21);    
    datetick('x','yyyymm','keeplimits');
    title('��������ȯ����ȯ����');
    subplot(3,2,3);
    plot_hist(sprd31);
    title('��������ȯ�δ���ȯ����ֲ�ͼ');
    subplot(3,2,4);
    plot(times,sprd31);
    datetick('x','yyyymm','keeplimits');
    title('��������ȯ�δ���ȯ����');
    subplot(3,2,5);
    plot_hist(sprd32);
    title('��������ȯ�δ���ȯ����ֲ�');
    subplot(3,2,6);
    plot(times,sprd32);
    datetick('x','yyyymm','keeplimits');
    title('��������ȯ�δ���ȯ����');
    
    
    
    w.close;
    
end

