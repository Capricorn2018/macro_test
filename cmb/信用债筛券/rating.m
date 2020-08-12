function ratings = rating(tickers,dt)

    w = windmatlab;
    
    dt_str = num2str(dt);

    tickers_str = strjoin(tickers,',');
    
    [data,~,~,~,~,~]=w.wsd(tickers_str,'rate_historicalMIR_cnbd',dt_str,dt_str);
    
    ratings = cell(length(data),1);
    
    for i = 1:length(data)
        ratings{i} = find_rating(data{i},dt);
    end
    
    w.close;
    
end



function latest_rating = find_rating(rating_str,dt)

    str = strsplit(rating_str,';');

    n = strlength(str);
    dates = zeros(length(str),1);

    latest_rating = "";
    last_rating = ""; %#ok<NASGU>

    for i=1:length(str)
        nn = n(i);
        st = str{i};
        dates(i) = str2double(st(nn-8:nn-1));
        last_rating=latest_rating;
        latest_rating = str{i}(1:(strfind(st,"(")-1));

        if dates(i) >= dt
            latest_rating = last_rating;
            break;
        end
    end
end