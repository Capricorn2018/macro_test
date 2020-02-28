function res = term_prem(start_dt,end_dt)
% 读取短期限利率和IRS数据, 计算市场隐含流动性溢价
    w = windmatlab;
    
    % 国债1,3,5,7,10,30
    % 国开1,3,5,7,10,20
    % FR007互换3M, FR007互换1Y, FR007互换5Y
    % 
    [yield,~,~,times,~,~] = w.edb(['S0059744,S0059746,S0059747,S0059748,S0059749,S0059752,',...
                                    'M1004263,M1004265,M1004267,M1004269,M1004271,M1004273,',...
                                    'M1004123,M1004126,M1004130'],...
                                    start_dt,end_dt);
                                
    bond1y = yield(:,1);
    bond3y = yield(:,2);
    bond5y = yield(:,3);
    bond7y = yield(:,4);
    bond10y = yield(:,5);
    bond30y = yield(:,6);
    
    cdb1y = yield(:,7);
    cdb3y = yield(:,8);
    cdb5y = yield(:,9);
    cdb7y = yield(:,10);
    cdb10y = yield(:,11);
    cdb20y = yield(:,12);
    
    irs3m = yield(:,13);
    irs1y = yield(:,14);
    irs5y = yield(:,15);
    
    irs1y_irs3m = irs1y - irs3m; % 短期资金预期
    irs5y_irs1y = irs5y - irs1y; % 长期资金预期
                                            
    bond3y_bond1y = bond3y - bond1y; % 国债期限利差
    bond5y_bond1y = bond5y - bond1y;
    bond10y_bond1y = bond10y - bond1y;
    
    figure(2);
    subplot(2,2,1);
    plot_hist(bond3y_bond1y);
    title('BOND3Y minus BOND1Y histogram');
    subplot(2,2,2);
    plot(times,bond3y_bond1y);
    datetick('x','yyyy','keeplimits');
    title('BOND3Y minus BOND1Y');
    axis tight;
    subplot(2,2,3);
    plot_hist(bond5y_bond1y);
    title('BOND5Y minus BOND1Y histogram');
    subplot(2,2,4);
    plot(times,bond5y_bond1y);
    datetick('x','yyyy','keeplimits');
    title('BOND5Y minus BOND1Y');
    axis tight;
    
    
    cdb3y_cdb1y = cdb3y - cdb1y; % 国开期限利差
    cdb5y_cdb1y = cdb5y - cdb1y;
    cdb10y_cdb1y = cdb10y - cdb1y;
    
    figure(3);
    subplot(2,2,1);
    plot_hist(cdb3y_cdb1y);
    title('CDB3Y minus CDB1Y histogram');
    subplot(2,2,2);
    plot(times,cdb3y_cdb1y);
    datetick('x','yyyy','keeplimits');
    title('CDB3Y minus CDB1Y');
    axis tight;
    subplot(2,2,3);
    plot_hist(cdb5y_cdb1y);
    title('CDB5Y minus CDB1Y histogram');
    subplot(2,2,4);
    plot(times,cdb5y_cdb1y);
    datetick('x','yyyy','keeplimits');
    title('CDB5Y minus CDB1Y');
    axis tight;
        
    bond5y_bond3y = bond5y - bond3y; % 骑乘
    bond10y_bond5y = bond10y - bond5y;
    cdb5y_cdb3y = cdb5y - cdb3y;
    cdb10y_cdb5y = cdb10y - cdb5y;
    
    bond10y_bond7y = bond10y - bond7y; % 7年曲度
    cdb10y_cdb7y = cdb10y - cdb7y;
    
    bond30y_bond1y = bond30y - bond1y; % 超长债溢价
    bond30y_bond10y = bond30y - bond10y;
    cdb20y_cdb1y = cdb20y - cdb1y;
    cdb20y_cdb10y = cdb20y - cdb10y;
    
    figure(3);
    subplot(2,2,1);
    plot_hist(bond30y_bond10y);
    title('BOND30Y minus BOND10Y histogram');
    subplot(2,2,2);
    plot(times,bond30y_bond10y);
    datetick('x','yyyy','keeplimits');
    title('BOND30Y minus BOND10Y');
    axis tight;
    subplot(2,2,3);
    plot_hist(cdb20y_cdb10y);
    title('CDB20Y minus CDB10Y histogram');
    subplot(2,2,4);
    plot(times,cdb20y_cdb10y);
    datetick('x','yyyy','keeplimits');
    title('CDB20Y minus CDB10Y');
    axis tight;    
    
    bond_curv = bond5y * 2 - bond1y - bond10y; % 曲线曲率
    cdb_curv = cdb5y * 2 - cdb1y - cdb10y;
    
    figure(4);
    subplot(2,2,1);
    plot_hist(bond_curv);
    title('BOND curvature histogram');
    subplot(2,2,2);
    plot(times,bond_curv);
    datetick('x','yyyy','keeplimits');
    title('BOND curvature');
    axis tight;
    subplot(2,2,3);
    plot_hist(cdb_curv);
    title('CDB curvature histogram');
    subplot(2,2,4);
    plot(times,cdb_curv);
    datetick('x','yyyy','keeplimits');
    title('CDB curvature');
    axis tight;   
      
    res = table(irs1y_irs3m,irs5y_irs1y,...
                bond3y_bond1y,bond5y_bond1y,bond10y_bond1y,...
                cdb3y_cdb1y,cdb5y_cdb1y,cdb10y_cdb1y,...
                bond5y_bond3y,bond10y_bond5y,cdb5y_cdb3y,cdb10y_cdb5y,...
                bond10y_bond7y,cdb10y_cdb7y,...
                bond30y_bond1y,bond30y_bond10y,cdb20y_cdb1y,cdb20y_cdb10y,...
                bond_curv,cdb_curv,...
                'VariableNames',...
                {'irs1y_irs3m','irs5y_irs1y',...
                 'bond3y_bond1y','bond5y_bond1y','bond10y_bond1y',...
                 'cdb3y_cdb1y','cdb5y_cdb1y','cdb10y_cdb1y',...
                 'bond5y_bond3y','bond10y_bond5y','cdb5y_cdb3y','cdb10y_cdb5y',...
                 'bond10y_bond7y','cdb10y_cdb7y',...
                 'bond30y_bond1y','bond30y_bond10y','cdb20y_cdb1y','cdb20y_cdb10y',...
                 'bond_curv','cdb_curv'});

end

