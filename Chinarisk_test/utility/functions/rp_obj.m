function obj = rp_obj(w,cm)
    
    % risk contribution ÿ���ʲ��ķ��չ���
    rc = (cm.*repmat(w,1,length(w)))*w;
    
    % ����ܷ���
    %variance = sqrt(sum(rc));
    variance = sum(rc);
    
    % ÿ���ʲ��ķ��չ���ռ��
    p = rc/variance;
    
    p(p<0)=0;
        
    % Ŀ�꺯��, ����ʹÿ���ʲ���rc���
    obj = sum( p .* log(p)); 
    %obj = (p - 1/length(p))' * (p - 1/length(p)) * 10000;
    %obj = sum( (rc(2:end)/rc(1)-1).^2 );
    
end