function [ reb ] = get_dates(file,numdays,direction)
% 从.mat文件中提取日期

    x = load(file);
    dates = x.assets.date;
    
    reb = find_month_dates(numdays,dates,direction);

end

