function [Lia,Locb] = match_date(date_mkt,date_macro)
% ������ݵ����ڶ���ÿ��1�գ���Ҫ���г����ݶ�Ӧ
% Lia: date_mkt��������Ƿ��Ӧdate_macro���ĳһ�����ڵ�����
% Locb: date_mkt������ڶ�Ӧ��date_macro������ڵ����
    
    fd_mkt = datenum(year(date_mkt),month(date_mkt),1);
    fd_mcr = date_macro + 1; %windȡ�����ĺ�����ݶ�Ӧ�����ں�����ÿ�������һ�죨ע�ⲻ�ǹ����գ�
    
    [Lia,Locb] = ismember(fd_mkt,fd_mcr);

end

