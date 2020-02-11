function res = credit_prem(start_dt,end_dt)
% credit_prem 用来算信用债溢价, 可以再加入一部分剥离流动性溢价
    w = windmatlab;
    
    % 按顺序分别是：
    % AAA+ 1Y, 3Y, 5Y
    % AAA 1Y, 3Y, 5Y
    % AA+ 1Y, 3Y, 5Y
    % 国债 1Y, 3Y, 5Y
    % 国开 1Y, 3Y, 5Y
    [yield,~,~,times,~,~]=w.edb(['M1000517,M1000519,M1000521,',...
                                 'M1000532,M1000534,M1000536,',...
                                 'M1000559,M1000561,M1000563,',...
                                 'M1000158,M1000160,M1000162,',...
                                 'M1004263,M1004265,M1004267'],start_dt,end_dt,'Fill=Previous');
                               
    aaap1y = yield(:,1);
    aaap3y = yield(:,2);
    aaap5y = yield(:,3);
    
    aaa1y = yield(:,4);
    aaa3y = yield(:,5);
    aaa5y = yield(:,6);
    
    aap1y = yield(:,7);
    aap3y = yield(:,8);
    aap5y = yield(:,9);
    
    bond1y = yield(:,10);
    bond3y = yield(:,11);
    bond5y = yield(:,12);
    
    cdb1y = yield(:,13);
    cdb3y = yield(:,14);
    cdb5y = yield(:,15);
    
    aaap1y_bond1y = aaap1y - bond1y;
    aaap3y_bond3y = aaap3y - bond3y;
    aaap5y_bond5y = aaap5y - bond5y;
    
    aaa1y_bond1y = aaa1y - bond1y;
    aaa3y_bond3y = aaa3y - bond3y;
    aaa5y_bond5y = aaa5y - bond5y;
    
    aap1y_bond1y = aap1y - bond1y;
    aap3y_bond3y = aap3y - bond3y;
    aap5y_bond5y = aap5y - bond5y;
    
    aaap1y_cdb1y = aaap1y - cdb1y;
    aaap3y_cdb3y = aaap3y - cdb3y;
    aaap5y_cdb5y = aaap5y - cdb5y;
    
    aaa1y_cdb1y = aaa1y - cdb1y;
    aaa3y_cdb3y = aaa3y - cdb3y;
    aaa5y_cdb5y = aaa5y - cdb5y;
    
    aap1y_cdb1y = aap1y - cdb1y;
    aap3y_cdb3y = aap3y - cdb3y;
    aap5y_cdb5y = aap5y - cdb5y;
    
    aaa1y_aaap1y = aaa1y - aaap1y;
    aaa3y_aaap3y = aaa3y - aaap3y;
    aaa5y_aaap5y = aaa5y - aaap5y;
    
    aap1y_aaap1y = aap1y - aaap1y;
    aap3y_aaap3y = aap3y - aaap3y;
    aap5y_aaap5y = aap5y - aaap5y;
    
    aap1y_aaa1y = aap1y - aaa1y;
    aap3y_aaa3y = aap3y - aaa3y;
    aap5y_aaa5y = aap5y - aaa5y;
    
    
    figure(2);
    subplot(3,2,1);
    plot_hist(aaa1y_bond1y);
    title('AAA1Y minus BOND1Y histogram');
    subplot(3,2,2);
    plot(times,aaa1y_bond1y);
    datetick('x','yyyy','keeplimits');
    title('AAA1Y minus BOND1Y');
    axis tight;
    subplot(3,2,3);
    plot_hist(aaa3y_bond3y);
    title('AAA3Y minus BOND3Y histogram');
    subplot(3,2,4);
    plot(times,aaa3y_bond3y);
    datetick('x','yyyy','keeplimits');
    title('AAA3Y minus BOND3Y');
    axis tight;subplot(3,2,5);
    plot_hist(aaa5y_bond5y);
    title('AAA5Y minus BOND5Y histogram');
    subplot(3,2,6);
    plot(times,aaa5y_bond5y);
    datetick('x','yyyy','keeplimits');
    title('AAA5y minus BOND5Y');
    axis tight;
    
      
    res = table(aaap1y_bond1y, aaap3y_bond3y, aaap5y_bond5y,...
                aaa1y_bond1y, aaa3y_bond3y, aaa5y_bond5y,...
                aap1y_bond1y, aap3y_bond3y, aap5y_bond5y,...
                aaap1y_cdb1y, aaap3y_cdb3y, aaap5y_cdb5y,...
                aaa1y_cdb1y, aaa3y_cdb3y, aaa5y_cdb5y,...
                aap1y_cdb1y, aap3y_cdb3y, aap5y_cdb5y,...
                aaa1y_aaap1y, aaa3y_aaap3y, aaa5y_aaap5y,...
                aap1y_aaap1y, aap3y_aaap3y, aap5y_aaap5y,...
                aap1y_aaa1y, aap3y_aaa3y, aap5y_aaa5y,...
                'VariableNames',...
                {'aaap1y_bond1y', 'aaap3y_bond3y', 'aaap5y_bond5y',...
                'aaa1y_bond1y', 'aaa3y_bond3y', 'aaa5y_bond5y',...
                'aap1y_bond1y', 'aap3y_bond3y', 'aap5y_bond5y',...
                'aaap1y_cdb1y', 'aaap3y_cdb3y', 'aaap5y_cdb5y',...
                'aaa1y_cdb1y', 'aaa3y_cdb3y', 'aaa5y_cdb5y',...
                'aap1y_cdb1y', 'aap3y_cdb3y', 'aap5y_cdb5y',...
                'aaa1y_aaap1y', 'aaa3y_aaap3y', 'aaa5y_aaap5y',...
                'aap1y_aaap1y', 'aap3y_aaap3y', 'aap5y_aaap5y',...
                'aap1y_aaa1y', 'aap3y_aaa3y', 'aap5y_aaa5y'});
    
    w.close;
    
end

