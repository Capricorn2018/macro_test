function res = term_prem(start_dt,end_dt)
% ��ȡ���������ʺ�IRS����, �����г��������������
    w = windmatlab;
    
    % ��ծ1,3,5,7,10,30
    % ����1,3,5,7,10,20
    % FR007����3M, FR007����1Y, FR007����5Y
    % 
    [yield,~,~,times,~,~] = w.edb(['S0059744,S0059746,S0059747,S0059748,S0059749,S0059752',...
                                    'M1004263,M1004265,M1004267,M1004269,M1004271,M1004273',...
                                    'M1004123,M1004126,M1004130'],...
                                    start_dt,end_dt); %#ok<ASGLU>
                                
    bond1y = yield(:,1);
    bond3y = yield(:,2);
    bond5y = yield(:,3);
    bond7y = yield(:,4);
    bond10y = yield(:,5);
    bond30y = yield(:,6);
    
    cdb1y = yield(:,7);
    cdb3y = yield(:,8);
    cdb5y = yield(:,9);
    cdb7y = yield(:,10);
    cdb10y = yield(:,11);
    cdb20y = yield(:,12);
    
    irs3m = yield(:,13);
    irs1y = yield(:,14);
    irs5y = yield(:,15);
    
    irs1y_irs3m = irs1y - irs3m; % �����ʽ�Ԥ��
    irs5y_irs1y = irs5y - irs1y; % �����ʽ�Ԥ��
                                            
    bond3y_bond1y = bond3y - bond1y; % ��ծ��������
    bond5y_bond1y = bond5y - bond1y;
    bond10y_bond1y = bond10y - bond1y;
    
    cdb3y_cdb1y = cdb3y - cdb1y; % ������������
    cdb5y_cdb1y = cdb5y - cdb1y;
    cdb10y_cdb1y = cdb10y - cdb1y;
        
    bond5y_bond3y = bond5y - bond3y; % ���
    bond10y_bond5y = bond10y - bond5y;
    cdb5y_cdb3y = cdb5y - cdb3y;
    cdb10y_cdb5y = cdb10y - cdb5y;
    
    bond10y_bond7y = bond10y - bond7y; % 7������
    cdb10y_cdb7y = cdb10y - cdb7y;
    
    bond30y_bond1y = bond30y - bond1y; % ����ծ���
    bond30y_bond10y = bond30y - bond10y;
    cdb20y_cdb1y = cdb20y - cdb1y;
    cdb20y_cdb10y = cdb20y - cdb10y;    
    
    bond_curv = bond5y * 2 - bond1y - bond10y; % ��������
    cdb_curv = cdb5y * 2 - cdb1y - cdb10y;
    
   
    
    res = table(shi3m_irs3m,cd3m_irs3m,shi3ms1y_irs1y,...
                bond1y_irs1y,cdb1y_irs1y,cd1y_irs1y,...
                irs1y_irs3m,irs5y_irs1y,...
                'VariableNames',...
                {'shi3m_irs3m','cd3m_irs3m','shi3ms1y_irs1y',...
                'bond1y_irs1y','cdb1y_irs1y','cd1y_irs1y',...
                'irs1y_irs3m','irs5y_irs1y'});

end

