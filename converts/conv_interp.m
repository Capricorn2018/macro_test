function model = conv_interp( conv )
% ��ʱ����conv��һ��table, �зֱ�Ϊ�۸�, ƽ��, ծ��

    stk = conv(:,2); % �ڶ�����ƽ��
    
    stk2 = stk * stk;
    
    p = conv(:,1);
    
    X = table(stk,stk2);    
    
    model = fitlm(X,p);

end

