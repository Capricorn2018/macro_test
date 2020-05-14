function m = match_date(data_dt,reb_dt)
%MATCH_DATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    date1 = data_dt;
    date2 = reb_dt;

    dt1 = date1(1);
    dt2 = date2(1);
    
    if dt2<=dt1
        disp('Error: in match_date(): dt2<=dt1');
        m = NaN;
        return;
    end
    
    f = date1 < dt2;
    n = 1:length(f);
    N = n(f);
    
    m = N(end);
    
    if dt2 - date1(m) > 10
        m = NaN;
        return;
    end
    
end

