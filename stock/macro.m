function [macro_data,macro_times,yield_data,yield_times] = macro(start_dt,end_dt)
% 读取宏观数据

    w = windmatlab;
    % CPI,PPI,M2,M1,PMI,PMI主要原材料购进价格,PMI从业人员,PMI生产,PMI新出口订单,
    % 工业增加值：国有企业当月同比,工业增加值:汽车制造业,工业企业:亏损企业亏损额累计同比,
    % 工业企业：利润总额累计同比,社会融资规模当月初值
    [macro_data,~,~,macro_times,~,~]=w.edb(['M0000612,M0001227,M0001385,M0001383,M0017126,',...
                                            'M0017134,M0017136,M0017127,M0017129,M0000548,',...
                                            'M0068071,M0000559,M0000557,M5541321'],start_dt,end_dt);
    % 国债1,3,5,10,国开10,农发10,收益率, 这里暂时打算回测一下期限利差过于窄的时候是不是对股票相对收益有影响
    [yield_data,~,~,yield_times,~,~] = w.edb(['S0059744,S0059746,S0059747,S0059749,',...
                                                'M1004271,M1007675'],start_dt,end_dt,...
                                                'Fill=Previous'); 

    
end

