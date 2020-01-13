function [ output_args ] = liq_prem(start_dt,end_dt)
% 此处显示有关此函数的摘要
%   此处显示详细说明
    w = windmatlab;
    
    % 利率互换收盘价, FR007 3M, FR007 1Y, FR007 5Y, SHIBOR互换1Y, SHIBOR 3M
    [irs,irs_codes,~,irs_times,~,~]=w.wsd(['FR007S3M.IR,','FR007S1Y.IR,','FR007S5Y.IR,',...
                                            'SHI3MS1Y.IR,','SHIBOR3M.IR'],...
                                             'close',start_dt,end_dt);
    
    % 国债1Y, 同业存单AAA 3m, 国开1Y
    [yield,yield_codes,~,yield_times,~,~] = w.edb('S0059744,M1004899,M1004263',...
                                                start_dt,end_dt,...
                                                'Fill=Previous'); 
                                            
    
    [times,ia,ib] = intersect(yield_times,irs_times);
    
    irs = irs(ia,:);
    yield = yield(ib,:);
    
    shibor3m_irs3m = irs(:,5) - irs(:,1);
    cd3m_irs3m = yield(:,2) - irs(:,1);
    
    shi3ms1y_irs1y = irs(:,4) - irs(:,2);
    
    bond1y_irs1y = yield(:,1) - irs(:,1);
    cdb1y_irs1y = yield(:,3) - irs(:,1);
    

end

