function [factors,assets] = wind_data(filename,start_dt,end_dt)
% 从wind api中读取数据
    
    w = windmatlab;
    % 国债1,5,10,国开10收益率
    [edb_data,edb_codes,~,edb_times,~,~] = w.edb('S0059744,S0059747,S0059749,M1004271',start_dt,end_dt,'Fill=Previous'); 
    % 国开0~1,1~3,3~5,5~7,7~10,沪深300,中债高信用1~3
    [wsd_data,~,~,wsd_times,~,~] = w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS,399300.SZ,CBA01921.CS','close',start_dt,end_dt);
    
    
    edb = array2table(edb_data,'VariableNames',edb_codes);
    
    factors = table();
    factors.date = edb_times;
    factors.sprd51 = edb.S0059747 - edb.S0059744;
    factors.curv1510 = 2 * edb.S0059747 - edb.S0059749 - edb.S0059744;
    factors.sprdfin = edb.M1004271 - edb.S0059749;
    
    names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551','HS300','CBA01921'};
    assets = array2table([wsd_times,wsd_data],'VariableNames',names);
        
    save(filename,'assets','factors');
    
    w.close()    

end

