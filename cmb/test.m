w = windmatlab;

start_dt = '2006-06-01';
end_dt = '2020-1-10';

% ����ծ1,3,5,7,10;
% ��ծ1,3,5,7,10
[edb_data,edb_codes,~,edb_times,~,~] = w.edb(['M1004263,M1004265,M1004267,',...
                                              'M1004269,M1004271,M1000158,',...
                                              'M1000160,M1000162,M1000164,',...
                                              'M1000166'],...
                                        start_dt,end_dt,'Fill=Previous'); 
edb = array2table(edb_data,'VariableNames',edb_codes);

%���û���õ�
% ����0~1,1~3,3~5,5~7,7~10,����300,��ծ������1~3
[ret_data,ret_codes,~,ret_times,~,~] = w.wsd(['CBA02511.CS,CBA02521.CS,',...
                                              'CBA02531.CS,CBA02541.CS,',...
                                              'CBA02551.CS,399300.SZ,',...
                                              'CBA01921.CS'],'close',start_dt,end_dt);
names = {'date','CBA02511','CBA02521','CBA02531','CBA02541','CBA02551','HS300','CBA01921'};
ret = array2table([ret_times,ret_data],'VariableNames',names);

factors = table();

% ������������
factors.date = edb_times;
factors.sprd101 = edb.M1004271 - edb.M1004263;

% �������������, �ù���5-��ծ5
factors.liq5y = edb.M1004267 - edb.M1000162;

% ���ɵ����գ������õ���ÿ���µڶ���������
reb = find_month_dates(2, ret_times, 'first'); 

% �����յ����ݶ���
[~,Locb] = ismember(reb, factors.date);
f = factors(Locb,2:end);

% ָ����������ݶ��룬���㳬������
[~,Locb] = ismember(reb,ret_times);
ret_reb = ret(Locb,:);
y1 = ret_reb.CBA02521; y2 = ret_reb.CBA02551;
y1 = [y1(2:end)./y1(1:end-1) - 1.;NaN];
y2 = [y2(2:end)./y2(1:end-1) - 1.;NaN];
y = y2 - y1;

% ��һ�нؾ���
f = table2array(f);
f = [ones(size(f,1),1),f];


% ��һ�¶���, AIC��������Իع�2�ܣ�����Ϊ�˽�Ƶ�����ϸ���
prev = [NaN;y(1:end-1)];
f = [f, prev];

% ��һ����������
% ���������15��3��֮ǰ�õ�PMI
% 15��3��֮���õ�PMI�͵ƹ����ݵļ�Ȩ
% PMI���ݶ�ȡ��ʵ��ֵ��ȥ15��3��֮��ľ�ֵ���ٳ��Է���
% �ƹ���������PMI�Ĵ���
% ���߼�Ȩ�õ�������PCA�ķ��� ((a-mean(a))/std(a) + (b-mean(b))/std(b))/(1+rho)
% ��������һ�������ݻؿ��ĳɷ֣�����˵��ֵ�ͷ��������������ʵ����ʷ̫��Ҳû�취
[res,~,~] = read_satellite(reb);
f = [f,res];

% ȥ�����һ�ڵ�����ȱʧ
y = y(1:end-1);
f = f(1:end-1,:);


% ��ʼ����40�����Ǹ���Ҷ�����ó���������
window = 40;

% Ԥ����
pred = nan(length(y),1);

for j=(window+1):length(y)

    % ����ع�
    mdl = fitlm(f(1:j-1,:),y(1:j-1));

    % �����ڵ��������ݺͱ��ڵĻع�������Ԥ������
    pred(j) = [1,f(j,:)] * mdl.Coefficients.Estimate;

end

signal = pred > 0;
close1 = ret.CBA02521;
close10 = ret.CBA02551;
r1 = [NaN;close1(2:end)./close1(1:end-1) - 1];
r10 = [NaN;close10(2:end)./close10(1:end-1) - 1];
ret_dt = ret_times;

[nav,nav_alpha,nav_dt] = show_results(reb, signal, r1, r10, ret_dt);

w.close();

