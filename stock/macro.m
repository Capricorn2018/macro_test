function [macro_data,macro_times] = macro(start_dt,end_dt)
% 读取宏观数据

    w = windmatlab;
    % CPI,PPI,M2,M1
    [macro_data,~,~,macro_times,~,~]=w.edb('M0000612,M0001227,M0001385,M0001383',start_dt,end_dt);
    % 国债1,3,5,10,国开10,农发10,收益率
    [yield_data,yield_codes,~,yield_times,~,~] = w.edb('S0059744,S0059746,S0059747,S0059749,M1004271,M1007675',start_dt,end_dt,'Fill=Previous'); 

end

