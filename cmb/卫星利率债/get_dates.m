function [ reb ] = get_dates(file,numdays,direction)
% ��.mat�ļ�����ȡ����

    x = load(file);
    dates = x.assets.date;
    
    reb = find_month_dates(numdays,dates,direction);

end

