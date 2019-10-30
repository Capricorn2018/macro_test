function model = conv_interp( conv )
% 暂时决定conv是一个table, 列分别为价格, 平价, 债底

    stk = conv(:,2); % 第二列是平价
    
    stk2 = stk * stk;
    
    p = conv(:,1);
    
    X = table(stk,stk2);    
    
    model = fitlm(X,p);

end

