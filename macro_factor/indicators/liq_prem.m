function res = liq_prem(start_dt,end_dt)
% �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    w = windmatlab;
    
    % ��ծ1Y, ͬҵ�浥AAA 3m, ����1Y, FR007����3M, FR007����1Y, FR007����5Y, SHIBOR����1Y,
    % SHIBOR 3M
    [yield,~,~,times,~,~] = w.edb(['S0059744,','M1004899,','M1004263,',...
                                                'M1004123,M1004126,M1004130,M1004084,M1001858'],...
                                                start_dt,end_dt); %#ok<ASGLU>
                                            
    shi3m_irs3m = yield(:,8) - yield(:,4); % 3m���������
    cd3m_irs3m = yield(:,2) - yield(:,4);
    
    shi3ms1y_irs1y = yield(:,7) - yield(:,5); % 1y���������    
    bond1y_irs1y = yield(:,1) - yield(:,5);
    cdb1y_irs1y = yield(:,3) - yield(:,5);
    
    irs1y_irs3m = yield(:,5) - yield(:,4); % �ʽ�Ԥ��
    irs5y_irs1y = yield(:,6) - yield(:,5);
    
    res = table(shi3m_irs3m,cd3m_irs3m,shi3ms1y_irs1y,...
                bond1y_irs1y,cdb1y_irs1y,irs1y_irs3m,irs5y_irs1y,...
                'VariableNames',...
                {'shi3m_irs3m','cd3m_irs3m','shi3ms1y_irs1y',...
                'bond1y_irs1y','cdb1y_irs1y','irs1y_irs3m','irs5y_irs1y'});
    

end

