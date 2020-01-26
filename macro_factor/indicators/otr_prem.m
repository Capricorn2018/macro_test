function [sprd21,sprd31,sprd32,times] =  otr_prem(start_dt,end_dt)
% otm_preme用来算国开10年新老券利差
    w = windmatlab;
    
    % 从otr_prem.xlsx中读入券表，发新券需要手动更新文件
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
    title('国开最新券次新券利差分布图');
    subplot(3,2,2);
    plot(times,sprd21);    
    datetick('x','yyyymm','keeplimits');
    title('国开最新券次新券利差');
    subplot(3,2,3);
    plot_hist(sprd31);
    title('国开最新券次次新券利差分布图');
    subplot(3,2,4);
    plot(times,sprd31);
    datetick('x','yyyymm','keeplimits');
    title('国开最新券次次新券利差');
    subplot(3,2,5);
    plot_hist(sprd32);
    title('国开次新券次次新券利差分布');
    subplot(3,2,6);
    plot(times,sprd32);
    datetick('x','yyyymm','keeplimits');
    title('国开次新券次次新券利差');
    
    
    
    w.close;
    
end

