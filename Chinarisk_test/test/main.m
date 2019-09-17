clear;clc; 
%%
cd('D:\Projects\macro_test\Chinarisk_test');
addpath(genpath(cd));
d.project_path = 'D:\Projects\macro_test\Chinarisk_test';
d.data_path     = 'D:\Projects\macro_test\Chinarisk_test\data\input'; 
d.output_path_base   = 'D:\Projects\macro_test\Chinarisk_test\data\output\base'; 
d.output_path  = d.output_path_base ;
%%
tklist1 = cell2table(  {'eqt','CSI300', '000300.SH','H00300.CSI';...
                              'eqt','CSI500', '000905.SH','H00905.CSI';...
                              'fi', 'CS1', 'H11001.CSI', 'H11001.CSI';...
                              'fi', 'IR1', 'CBA02531.CS', 'CBA02531.CS';...
                              'comdty_c','CU','NH0012.NHF','NH0012.NHF';...
                              'comdty_c','AU','AU9999.SGE','AU9999.SGE';...
                              'cash','CASH','H11025.CSI','H11025.CSI'},...
                              'VariableNames',{'asset_class','name','index_vol','index_rtn'});

%% π…∆±’Æ»Ø…Ã∆∑
p.ticker_list = tklist1;
p = set_paras(d,p); 
need_load_data = 0; 
if need_load_data
    load_data(d,p); 
end 
p = set_paras(d,p);

x = [0.04];
summary_stats  = zeros(length(x),5);
for i  =1: length(x)
    tic;
       p.tgt_vol = x(i);
       [simulated_nav,allocation, allocation_detail, summary_stats(i,:) ] =  get_tgt_vol_portfolio(d,p, datenum(2005,1,1)); 
       save([d.output_path_base ,'\rp_',num2str(x(i)*100),'.mat'],'simulated_nav','allocation','allocation_detail');
       make_plots_(table2array(simulated_nav),d,p, ['\rp_',num2str(x(i)*100)])
       clear simulated_nav allocation allocation_detail
     toc;
end
equity_bond_comdty = array2table(summary_stats,'VariableNames',{'tgt_vol','rtn','vol','ratio','maxdd'});
save([d.output_path_base ,'\rp_stat.mat'],'equity_bond_comdty');
