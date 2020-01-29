function [macro_data,macro_times,yield_data,yield_times] = macro(start_dt,end_dt)
% ��ȡ�������

    w = windmatlab;
    % CPI,PPI,M2,M1,PMI,
    % PMI��Ҫԭ���Ϲ����۸�,PMI��ҵ��Ա,PMI����,PMI�³��ڶ���,��ҵ����ֵ��������ҵ����ͬ��,
    % ��ҵ����ֵ:��������ҵ,��ҵ��ҵ:������ҵ������ۼ�ͬ��,��ҵ��ҵ�������ܶ��ۼ�ͬ��,������ʹ�ģ���³�ֵ
    [macro_data,macro_codes,~,macro_times,~,~]=w.edb(['M0000612,M0001227,M0001385,M0001383,M0017126,',...
                                            'M0017134,M0017136,M0017127,M0017129,M0000548,',...
                                            'M0068071,M0000559,M0000557,M5541321'],start_dt,end_dt);
    macro_data = array2table(macro_data,'VariableNames',macro_codes);
    % ��ծ1,3,5,10,����10,ũ��10,������, ������ʱ����ز�һ�������������խ��ʱ���ǲ��ǶԹ�Ʊ���������Ӱ��
    [yield_data,yield_codes,~,yield_times,~,~] = w.edb(['S0059744,S0059746,S0059747,S0059749,',...
                                                'M1004271,M1007675'],start_dt,end_dt,...
                                                'Fill=Previous'); 
                                            
    [stk_data,stk_codes,~,stk_times,~,~] = w.wsd('000300.SH,000905.SH,HSI.HI,NH0200.NHF',...
                                            'close',start_dt,end_dt);
    % Ԥ��ƽ��ֵ��CPI����ͬ��, Ԥ��ƽ��ֵ��PPI����ͬ��, GDP�ּ��ۼ�ͬ��, Ԥ��ƽ��ֵ��GDPͬ�ȣ��꣩, 70���½�סլ�۸�ָ��
    [growth_data,growth_codes,~,growth_times,~,~] = w.edb('M0061676,M0061677,M0001395,M0329172,S2707403',...
                                                        start_dt,end_dt,'Fill=Previous');
    yield_data = array2table(yield_data,'VariableNames',yield_codes);
    
    % �������Ҫ��һЩԤ����, ��ԭʼ��������������һ������
    % ������hpfilter�������˲�, MA��ͬ��ȥ������
    % �����������һ��SEATS��matlab��
    
    % ��֤�ڻ��ı����������˺�����ݵ�������ݻع�, �õ�IVX�ع�, ���ܶ�������������զ����
    
    
end