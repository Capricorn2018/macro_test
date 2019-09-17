function pref = get_pref( nav,transaction_cost )
      % nav = simulated_nav(:,1:2);
      years = year(nav(1,1)):1:year(nav(end,1));  
  
      num_of_dates =  NaN(length(years),1);
      
      for i = 1: length(years)
          num_of_dates(i) = sum(years(i)==year(nav(:,1)));
      end
      
      if num_of_dates(1) == 1, years(1) = []; end
      if num_of_dates(end) == 1, years(end) = []; end
      if isempty(years), pref = talbe; return; end;
      
      stats = NaN(length(years)+1,6);
          
      for i = 1: length(years)
          if i==1
              idx1 = 1;
          else
              idx1 = find(year(nav(:,1))<years(i),1,'last');
          end
          
          if i==length(years)
               idx2 = size(nav,1);
          else
               idx2 = find(year(nav(:,1))==years(i),1,'last');
          end
          
           data_this_year = nav(idx1:idx2,:);
           stats(i,1) = data_this_year(end,2)/data_this_year(1,2) - 1;
           stats(i,2) = std(data_this_year(2:end,2)./data_this_year(1:end-1,2)-1)*sqrt(250);
           stats(i,3) = stats(i,1)/stats(i,2);
           [stats(i,4), MaxDDIndex] = maxdrawdown(data_this_year(:,2));
           if ~any(isnan(MaxDDIndex))
              stats(i,5) =(data_this_year(MaxDDIndex(2),1) - data_this_year(MaxDDIndex(1),1))/365;
           end
           stats(i,6) = nansum(transaction_cost(years(i)==year(transaction_cost(:,1)),2));
      end
      
        i = length(years)+1;
        t = (nav(end,1)-nav(1,1))/365;
        stats(i,1) = power(nav(end,2)/nav(1,2),1/t)-1;
        stats(i,2) = std(nav(2:end,2)./nav(1:end-1,2)-1)*sqrt(250);
        stats(i,3) = stats(i,1)/stats(i,2);
        [stats(i,4), MaxDDIndex] = maxdrawdown(nav(:,2));
        if ~any(isnan(MaxDDIndex))
          stats(i,5) =(nav(MaxDDIndex(2),1) - nav(MaxDDIndex(1),1))/365;  
        end
        stats(i,6) = nansum(transaction_cost(:,2))/t;
        years = [years,0];
        pref = array2table([years',stats],'VariableNames',{'year','rtn','vol','ratio','maxdd','maxddd','turn'});
        
end

