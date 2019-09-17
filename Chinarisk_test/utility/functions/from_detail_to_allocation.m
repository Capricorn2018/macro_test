function  [allocation] = from_detail_to_allocation(p,allocation_detail)

    allocation = array2table([allocation_detail.DATEN,zeros(height(allocation_detail),4)],'VariableNames',{'DATEN','EQT','COMDTY','FI','Cash'});
    
    [~,id_eqt]    = ismember(p.selected_eqt,   p.selected);
    [~,id_fi]     = ismember(p.selected_fi,    p.selected);
    [~,id_comdty] = ismember(p.selected_comdty,p.selected);
    
    
    allocation.EQT    = sum(table2array(allocation_detail(:,id_eqt+1)),2);
    allocation.COMDTY = sum(table2array(allocation_detail(:,id_comdty+1)),2);
    allocation.FI     = sum(table2array(allocation_detail(:,id_fi+1)),2);
    allocation.Cash   =  allocation_detail.Cash;
end