function [ output_args ] = liq_prem(start_dt,end_dt)
% 此处显示有关此函数的摘要
%   此处显示详细说明
    w = windmatlab;
    
    % 国债1Y, 同业存单AAA 3m, 国开1Y, FR007互换3M, FR007互换1Y, FR007互换5Y, SHIBOR互换1Y,
    % SHIBOR 3M
    [yield,yield_codes,~,yield_times,yield_error,~] = w.edb(['S0059744,','M1004899,','M1004263,',...
                                                'M0048483,','M0048486,','M0048490,',...
                                                'M0048499,','M0017142,'],...
                                                start_dt,end_dt); 
    % FR007互换3M, FR007互换1Y, FR007互换5Y, SHIBOR互换1Y,SHIBOR 3M                                        
    [irs,irs_codes,~,irs_times,irs_error,~] = w.edb('M1004123,M1004126,M1004130,M1004084,M1001858',...
                                                start_dt,end_dt); 
                                            
    shi3m_irs3m = yield(:,8) - yield(:,4);
    cd3m_irs3m = yield(:,2) - yield(:,4);
    
    shi3ms1y_irs1y = yield(:,7) - yield(:,5);
    
    bond1y_irs1y = yield(:,1) - yield(:,5);
    cdb1y_irs1y = yield(:,3) - yield(:,5);
    
    irs1y_irs3m = yield(:,5) - yield(:,4);
    irs5y_irs1y = yield(:,6) - yield(:,5);
    

end

