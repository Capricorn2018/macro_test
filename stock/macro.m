function [macro_data,macro_times] = macro(start_dt,end_dt)
% ��ȡ�������

    w = windmatlab;
    % CPI,PPI,M2,M1
    [macro_data,~,~,macro_times,~,~]=w.edb('M0000612,M0001227,M0001385,M0001383',start_dt,end_dt);
    % ��ծ1,3,5,10,����10,ũ��10,������
    [yield_data,yield_codes,~,yield_times,~,~] = w.edb('S0059744,S0059746,S0059747,S0059749,M1004271,M1007675',start_dt,end_dt,'Fill=Previous'); 

end

