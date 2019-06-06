% Ѱ��ÿ���µĵ�num��������, ������num��������
% num: ����, Ѱ�ҵĽ����ն�Ӧ������
% trading_dates: ��ʽ��datenum, ��һ�н�����
% direction: ��������˲�����Ĭ��Ϊ'first'
%            'first'����ÿ�������Ѱ�ҵ�num��������
%            'last'����ÿ������ĩѰ�ҵ�����num��������

function  [dates, dates_idx] = find_month_dates( num, trading_dates, direction)

    % �����������������direction, ��Ĭ��Ϊ'first'
    % ��Ѱ��ÿ���µ�num��������
    if(nargin<3)
        direction='first';
    end

    % �Ȱ����������Է����������
    dates_num = sort(trading_dates);
    
    % ת����char��ȡ�����, �� yr_mth = '199012'
    dates_str = datestr(dates_num,'yyyymmdd');
    yr_mth = dates_str(:,1:6);
    
    % ������ת����double�Է���תtable
    yr_mth = str2num(yr_mth); %#ok<ST2NM>
    
    % ���������ֺ������ն�Ӧdatenum����table
    ds = [array2table(yr_mth),array2table(dates_num)];
    
    % ��grpstats����ͬ��ͬ��Ϊһ��, ÿ����ȡ��Ҫ����һ��������
    func = @(x) grp_indexing(x,num,direction);
    ds = grpstats(ds,'yr_mth',func);   
    
    % ���ظ�ֵ
    dates = ds.Fun1_dates_num;
    
    dates_idx = zeros(length(dates),1);
    for i = 1:length(dates)
       dates_idx(i) = find(trading_dates == dates(i),1,'first');
    end
    
    %dates = dates(~isnan(rebalance_dates));

end

% direction=='first': Ѱ��x�ĵ�num��Ԫ��
% direction=='last': Ѱ��x�ĵ�����num��Ԫ��
function y=grp_indexing(x,num,direction)

    if(strcmp(direction,'first'))
        if(length(x)>=num)
            y=x(num); % ��num��Ԫ��
        else
            y=NaN;
        end
    elseif(strcmp(direction,'last'))
        if(length(x)>=num)
            y=x(length(x)-num+1); % ������num��Ԫ��
        else
            y=NaN;
        end
    else
        % ���direction���Ĳ����򱨴�
        disp('Error: wrong direction in find_month_dates.m');
        return;
    end
    
end

