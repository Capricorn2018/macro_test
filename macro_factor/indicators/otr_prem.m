function [sprd21,sprd31,sprd32,times] =  otr_prem(bond_list,start_dt,end_dt)
% otm_prem用来算国开10年新老券利差
    w = windmatlab;

    
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
    
    w.close;
    
end

