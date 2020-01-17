function plot_hist(x)
% 用x画出分布直方图并且标注出最新一期的所处位置
    y = x(end);
    
    [n,a] = hist(x,50);
    
    f = a>y;

    if any(f)
        [~,idx] = ismember(1,f);
        yy = zeros(size(n));
        yy(idx) =  n(idx);
    else
        yy = zeros(size(n));
        yy(end) = n(end);
    end
    
    h1 = bar(a,n,'hist'); %#ok<NASGU>
    hold on;
    h2 = bar(a,yy,'hist');
    
    set(h2,'facecolor','red');
    hold off;
    
end

