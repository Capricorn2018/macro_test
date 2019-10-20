function [factors,assets] = wind_data(filename,start_dt,end_dt)
% ��wind api�ж�ȡ����
    
    w = windmatlab;
    % ��ծ1,2,3,5,7,10,����10,ũ��10,5����ƱAAA,����5��,FR007���ʻ���1Y,SHIBOR3M���ʻ���1Y,������
    [edb_data,edb_codes,~,edb_times,~,~] = w.edb(['S0059744,S0059745,S0059746,S0059747,S0059748,',...
                                                    'S0059749,M1004271,M1007675,S0059739,',...
                                                    'M1004267,M0048517,M0048504'],start_dt,end_dt,'Fill=Previous'); 
    % ����0~1,1~3,3~5,5~7,7~10,����300,��ծ������1~3
    [wsd_data,~,~,wsd_times,~,~] = w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS,399300.SZ,CBA01921.CS','close',start_dt,end_dt);
    
    
    edb = array2table(edb_data,'VariableNames',edb_codes);
    
    factors = table();
    factors.date = edb_times;
    factors.sprd31 = edb.S0059746 - edb.S0059744;
    factors.sprd51 = edb.S0059747 - edb.S0059744;
    factors.sprd710 = edb.S0059748 - edb.S0059749; % ��ծ7-10�������5-1��1510������������һ��������ʤ��
    factors.curv1510 = 2 * edb.S0059747 - edb.S0059749 - edb.S0059744;
    factors.curv135 = 2 * edb.S0059746 - edb.S0059747 - edb.S0059744;
    factors.curv2510 = 2* edb.S0059746 - edb.S0059747 - edb.S0059745;
    factors.sprdfin = edb.M1004271 - edb.S0059749;    
    factors.sprdliq = edb.M1007675 - edb.M1004271;
    factors.sprdAAA = edb.S0059739 - edb.M1004267; % ���������5-1��1510�������Ҳ���������ʤ��
    
    factors.sprdswap = edb.M0048517 - edb.M0048504; % SHIBOR��FR007���ʻ���1Y����, ��5-1��1510������������������ʤ��
    
    names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551','HS300','CBA01921'};
    assets = array2table([wsd_times,wsd_data],'VariableNames',names);
        
    save(filename,'assets','factors');
    
    w.close()    

end

