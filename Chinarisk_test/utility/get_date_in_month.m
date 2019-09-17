function [ datei_series ] = get_date_in_month( model_trading_dates, datei )
     datei_series_ = sort(unique(eomdate(model_trading_dates)));
     datei_series  = zeros(size(datei_series_));
     for i = 1 : size(datei_series_,1)              
         dates_this_month = model_trading_dates(year(model_trading_dates)==year(datei_series_(i))&month(model_trading_dates)==month(datei_series_(i)));
         if  ~isempty(find(day(dates_this_month)<=datei,1,'last'))
             datei_series(i,1) = dates_this_month(find(day(dates_this_month)<=datei,1,'last'),1);
         else
             datei_series(i,1) = dates_this_month(find(day(dates_this_month)>=datei,1,'first'),1);
         end
         clear dates_this_month;
     end  
end

