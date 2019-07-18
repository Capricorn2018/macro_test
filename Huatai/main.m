w = windmatlab;
w.menu();

credit;
prices;

econ = [inflation,array2table(fin_growth)];

data = movmean(table2array(econ(:,2:end)),3,1);
isnum = ~any(isnan(data),2);

data = [econ(isnum,1),array2table(data(isnum,:))];
