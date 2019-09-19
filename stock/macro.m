function [macro_data,macro_times,yield_data,yield_times] = macro(start_dt,end_dt)
% 读取宏观数据

    w = windmatlab;
    % CPI,PPI,M2,M1,PMI,
    % PMI主要原材料购进价格,PMI从业人员,PMI生产,PMI新出口订单,工业增加值：国有企业当月同比,
    % 工业增加值:汽车制造业,工业企业:亏损企业亏损额累计同比,工业企业：利润总额累计同比,社会融资规模当月初值
    [macro_data,macro_codes,~,macro_times,~,~]=w.edb(['M0000612,M0001227,M0001385,M0001383,M0017126,',...
                                            'M0017134,M0017136,M0017127,M0017129,M0000548,',...
                                            'M0068071,M0000559,M0000557,M5541321'],start_dt,end_dt);
    macro_data = array2table(macro_data,'VariableNames',macro_codes);
    % 国债1,3,5,10,国开10,农发10,收益率, 这里暂时打算回测一下期限利差过于窄的时候是不是对股票相对收益有影响
    [yield_data,yield_codes,~,yield_times,~,~] = w.edb(['S0059744,S0059746,S0059747,S0059749,',...
                                                'M1004271,M1007675'],start_dt,end_dt,...
                                                'Fill=Previous'); 
                                            
    [stk_data,stk_codes,~,stk_times,~,~] = w.wsd('000300.SH,000905.SH,HSI.HI,NH0200.NHF',...
                                            'close',start_dt,end_dt);
    % 预测平均值：CPI当月同比, 预测平均值：PPI当月同比, GDP现价累计同比, 预测平均值：GDP同比（年），百城住宅价格指数同比
    [growth_data,growth_codes,~,growth_times,~,~] = w.edb('M0061676,M0061677,M0001395,M0329172,S2704485',...
                                                        start_dt,end_dt,'Fill=Previous');
    yield_data = array2table(yield_data,'VariableNames',yield_codes);
    
    % 下面可能要做一些预处理, 用原始的收益率数据算一下利差
    % 还有用hpfilter函数做滤波, MA和同比去季节性
    % 后面可以再试一下SEATS的matlab包
    
    % 东证期货的报告里面用了宏观数据的面板数据回归, 用的IVX回归, 下周二可以问问他们咋做的
    
    
end