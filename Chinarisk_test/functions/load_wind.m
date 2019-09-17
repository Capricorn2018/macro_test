function M = load_wind(tk)
     w = windmatlab; w.menu;
    [x,~,~,y,~,~]= w.wsd(tk,'close','1995-01-01',datestr(today(),'yyyy-mm-dd'));
     
    M = array2table([y,x],'VariableNames',{'DATEN','PRICE'});
    M(isnan(M.PRICE),:) = [];
    m = table2array(M);
    M = array2table([m(:,1),[0;m(2:end,2)./m(1:end-1,2)-1]],'VariableNames',{'DATEN','RTN'});
end