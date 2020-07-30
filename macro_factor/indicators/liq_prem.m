function liq = liq_prem(start_dt,end_dt)
% ��ȡ���������ʺ�IRS����, �����г��������������
    w = windmatlab;
    
    % ͬҵ�浥AAA 3m, ��ծ1Y, ����1Y, ͬҵ�浥AAA 1Y 
    % FR007����3M, FR007����1Y, FR007����5Y, SHIBOR����1Y, SHIBOR 3M
    % 
    [yield,~,~,times,~,~] = w.edb(['M1010882,S0059744,M1004263,M1010885,',...
                                    'M1004123,M1004126,M1004130,M1004084,M1001858'],...
                                    start_dt,end_dt);
                                            
    shi3m_irs3m = yield(:,9) - yield(:,5); % 3m���������
    cd3m_irs3m = yield(:,1) - yield(:,5); % 3m�浥������
    
    shi3ms1y_irs1y = yield(:,8) - yield(:,6); % 1Y SHIBOR����������  
    bond1y_irs1y = yield(:,2) - yield(:,6); % 1Y��ծ������
    cdb1y_irs1y = yield(:,3) - yield(:,6); % 1Y����������
    cd1y_irs1y = yield(:,4) - yield(:,6); % 1Y�浥������
    
    figure(2);
    subplot(2,2,1);
    plot_hist(shi3m_irs3m);
    title('SHIBOR3M minus IRS3M histogram');
    subplot(2,2,2);
    plot(times,shi3m_irs3m);
    datetick('x','yyyy','keeplimits');
    title('SHIBOR3M minus IRS3M');
    axis tight;
    subplot(2,2,3);
    plot_hist(cd3m_irs3m);
    title('CD3M minus IRS3M histogram');
    subplot(2,2,4);
    plot(times,cd3m_irs3m);
    datetick('x','yyyy','keeplimits');
    title('CD3M minus IRS3M');
    axis tight;
    
    figure(3);
    subplot(2,2,1);
    plot_hist(shi3ms1y_irs1y);
    title('SHIBOR3M1Y minus IRS1Y histogram');
    subplot(2,2,2);
    plot_hist(bond1y_irs1y);
    title('BOND1Y minus IRS1Y histogram');
    subplot(2,2,3);
    plot_hist(cdb1y_irs1y);
    title('CDB1Y minus IRS1Y histogram');
    subplot(2,2,4);
    plot_hist(cd1y_irs1y);
    title('CD1Y minus IRS1Y histogram');
    
    figure(4);
    subplot(2,2,1);
    plot(times,shi3ms1y_irs1y);
    datetick('x','yyyy','keeplimits');
    title('SHIBOR3M1Y minus IRS1Y');
    axis tight;
    subplot(2,2,2);
    plot(times,bond1y_irs1y);
    datetick('x','yyyy','keeplimits');
    title('BOND1Y minus IRS1Y');
    axis tight;
    subplot(2,2,3);
    plot(times,cdb1y_irs1y);
    datetick('x','yyyy','keeplimits');
    title('CDB1Y minus IRS1Y');
    axis tight;
    subplot(2,2,4);
    plot(times,cd1y_irs1y);
    datetick('x','yyyy','keeplimits');
    title('CD1Y minus IRS1Y');
    axis tight;
    
    
    liq = table(times,shi3m_irs3m,cd3m_irs3m,shi3ms1y_irs1y,...
                bond1y_irs1y,cdb1y_irs1y,cd1y_irs1y,...
                'VariableNames',...
                {'times','shi3m_irs3m','cd3m_irs3m','shi3ms1y_irs1y',...
                'bond1y_irs1y','cdb1y_irs1y','cd1y_irs1y'});
    
    w.close;
end

