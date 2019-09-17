function obj = rp_obj(w,cm)
    
    % risk contribution 每个资产的风险贡献
    rc = (cm.*repmat(w,1,length(w)))*w;
    
    % 组合总风险
    %variance = sqrt(sum(rc));
    variance = sum(rc);
    
    % 每个资产的风险贡献占比
    p = rc/variance;
    
    p(p<0)=0;
        
    % 目标函数, 尽量使每个资产的rc相等
    obj = sum( p .* log(p)); 
    %obj = (p - 1/length(p))' * (p - 1/length(p)) * 10000;
    %obj = sum( (rc(2:end)/rc(1)-1).^2 );
    
end