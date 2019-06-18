function [q1,q2,q3,q4] = region4(x,y,ret)

    q1 = mean(ret(x>=median(x) & y>=median(y)),'omitnan');
    q2 = mean(ret(x>=median(x) & y<median(y)),'omitnan');
    q3 = mean(ret(x<median(x) & y<median(y)),'omitnan');
    q4 = mean(ret(x<median(x) & y>=median(y)),'omitnan');

end

