function [macro_data,macro_times] = macro()
% 读取宏观数据

    w = windmatlab;
    % CPI,PPI,国债5y,国债1y,M2,M1
    [macro_data,~,~,macro_times,~,~]=w.edb('M0000612,M0001227,S0059747,S0059744,M0001385,M0001383','2002-06-09','2019-08-09','Fill=Previous');

end

