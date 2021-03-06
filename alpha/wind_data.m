function [factors,assets] = wind_data(filename,start_dt,end_dt)
% 从wind api中读取数据
    
    w = windmatlab;
    % 国债1,2,3,5,7,10,国开10,农发10,5年中票AAA,国开5年,FR007利率互换1Y,SHIBOR3M利率互换1Y,FR007利率互换1Y(日频)
    [edb_data,edb_codes,~,edb_times,~,~] = w.edb(['S0059744,S0059745,S0059746,S0059747,S0059748,',...
                                                    'S0059749,M1004271,M1007675,S0059739,',...
                                                    'M1004267,M1004003,M1004036,M0048486'],start_dt,end_dt,'Fill=Previous'); 
    % 国开0~1,1~3,3~5,5~7,7~10,沪深300,中债高信用1~3
    [wsd_data,~,~,wsd_times,~,~] = w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS,399300.SZ,CBA01921.CS,NH0200.NHF','close',start_dt,end_dt);
    
    
    edb = array2table(edb_data,'VariableNames',edb_codes);
    
    factors = table();
    factors.date = edb_times;
    factors.sprd31 = edb.S0059746 - edb.S0059744;
    factors.sprd51 = edb.S0059747 - edb.S0059744;
    factors.sprd710 = edb.S0059748 - edb.S0059749; % 国债7-10，跟5-1和1510结合起来能提高一点点做多的胜率
    factors.curv1510 = 2 * edb.S0059747 - edb.S0059749 - edb.S0059744;
    factors.curv135 = 2 * edb.S0059746 - edb.S0059747 - edb.S0059744;
    factors.curv2510 = 2* edb.S0059746 - edb.S0059747 - edb.S0059745;
    factors.curv123 = 2*edb.S0059745 - edb.S0059744 - edb.S0059747;
    factors.sprdfin = edb.M1004271 - edb.S0059749;
    factors.taxfin = edb.M1004271 ./ edb.S0059749 - 1;
    
    factors.sprdliq = edb.M1007675 - edb.M1004271;
    factors.sprdAAA = edb.S0059739 - edb.S0059747; % 信用利差，跟5-1和1510结合起来也能提高做多胜率
    
    factors.sprdswap = edb.M1004003 - edb.M1004036; % SHIBOR与FR007利率互换1Y利差, 跟5-1和1510结合起来可以提高做多胜率
    factors.sprd51swap = edb.S0059747 - edb.M0048486; % 5年国债减FR007互换1Y
    factors.bondswap = edb.M0048486 - edb.S0059744; % swap1Y减去国债1y
    
    names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551','HS300','CBA01921','NH0200'};
    assets = array2table([wsd_times,wsd_data],'VariableNames',names);
        
    save(filename,'assets','factors');
    
    w.close()    

end

