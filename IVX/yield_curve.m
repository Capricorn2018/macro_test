start_dt = '1990-01-01';
end_dt = '2019-10-25';
file = 'D:/Projects/macro_test/IVX/IVX_data.mat'; % �����wind��load�����ݵ��ļ�

w = windmatlab;

 % ��ծ����������1Y,2Y,3Y,4Y,5Y
[edb_data,edb_codes,~,edb_times,~,~] = w.edb('M1001102,M1001103,M1001104,M1001105,M1001106',...
                                                start_dt,end_dt,'Fill=Previous'); 

% ����0~1,1~3,3~5,5~7,7~10ָ��
[wsd_data,~,~,wsd_times,~,~] = w.wsd('CBA02511.CS,CBA02521.CS,CBA02531.CS,CBA02541.CS,CBA02551.CS',...
                                        'close',start_dt,end_dt);
                                   
edb = array2table(edb_data,'VariableNames',edb_codes);

factors = table();
factors.date = edb_times;
factors.spot1y = edb.M1001102;
factors.fwd1y2y = 2*edb.M1001103 - edb.M1001102;   % 1Y~2Y��Զ������
factors.fwd2y3y = 3*edb.M1001104 - 2*edb.M1001103; % 2Y~3Y��Զ������
factors.fwd3y4y = 4*edb.M1001105 - 3*edb.M1001104; % 3Y~4Y��Զ������
factors.fwd4y5y = 5*edb.M1001106 - 4*edb.M1001105; % 4Y~5Y��Զ������

names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551'};
assets = array2table([wsd_times,wsd_data],'VariableNames',names);

save(filename,'assets','factors');                                   

reb = get_dates(file,5,'last');

reb(end) = datenum('2019-10-25'); % ����һ����ÿ���µ��������������
[~,ret] = load_assets(file,reb); 

factor = load_factor(file,reb);
tbl = merge_xy(factor, ret);

tbl_orig = tbl;
tbl = tbl(year(tbl.date)>=2005,:);

r0 = tbl.CBA02511_lag3d; % 0~1
r1 = tbl.CBA02521_lag3d; % 1`3
r5 = tbl.CBA02531_lag3d; % 3~5
r10 = tbl.CBA02551_lag3d; % 7~10

yt = r5-r1;
xt = tbl(:,['spot1y','fwd1y2y','fwd2y3y','fwd3y4y','fwd4y5y']);

% ��������Ƕ����𹤸��ҵ��Ǹ�py�ĺ���, �����ô���һ�û��̫�����
% ivxlh(yt,xt,1);
                                            


