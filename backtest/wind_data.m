function [] = wind_data(fields,start_dt,end_dt)
% ��wind api�ж�ȡ����
    % ��ծ1,5,10,����10
    w.edb('S0059749,S0059747,S0059744,M1004271','2018-06-26','2019-06-26','Fill=Previous'); 
    % ����0~1,1~3,3~5,5~7,7~10,����300,��ծ������1~3
    w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS,399300.SZ,CBA01921.CS','close','2019-05-27','2019-06-25')��
    
    

end

