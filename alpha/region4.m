function [q1,q2,q3,q4] = region4(x,y,ret)
% 对因子x,y的四象限分解，看两因子配合后对收益ret的分类影响
    q1 = mean(ret(x>=median(x) & y>=median(y)),'omitnan');
    q2 = mean(ret(x>=median(x) & y<median(y)),'omitnan');
    q3 = mean(ret(x<median(x) & y<median(y)),'omitnan');
    q4 = mean(ret(x<median(x) & y>=median(y)),'omitnan');

end

