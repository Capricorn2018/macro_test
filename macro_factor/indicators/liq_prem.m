function res = liq_prem(start_dt,end_dt)
% 读取短期限利率和IRS数据, 计算市场隐含流动性溢价
    w = windmatlab;
    
    % 同业存单AAA 3m, 国债1Y, 国开1Y, 同业存单AAA 1Y 
    % FR007互换3M, FR007互换1Y, FR007互换5Y, SHIBOR互换1Y, SHIBOR 3M
    % 
    [yield,~,~,times,~,~] = w.edb(['M1010882,S0059744,M1004263,M1010885,',...
                                    'M1004123,M1004126,M1004130,M1004084,M1001858'],...
                                    start_dt,end_dt); %#ok<ASGLU>
                                            
    shi3m_irs3m = yield(:,9) - yield(:,5); % 3m流动性溢价
    cd3m_irs3m = yield(:,1) - yield(:,5);
    
    shi3ms1y_irs1y = yield(:,8) - yield(:,6); % 1y流动性溢价    
    bond1y_irs1y = yield(:,2) - yield(:,6);
    cdb1y_irs1y = yield(:,3) - yield(:,6);
    cd1y_irs1y = yield(:,4) - yield(:,6);
    
    res = table(shi3m_irs3m,cd3m_irs3m,shi3ms1y_irs1y,...
                bond1y_irs1y,cdb1y_irs1y,cd1y_irs1y,...
                irs1y_irs3m,irs5y_irs1y,...
                'VariableNames',...
                {'shi3m_irs3m','cd3m_irs3m','shi3ms1y_irs1y',...
                'bond1y_irs1y','cdb1y_irs1y','cd1y_irs1y'});
    

end

