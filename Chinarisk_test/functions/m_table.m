function c =  m_table(a,b)

    eoma = get_date_in_month(a.DATEN,31);
    eom_a = zeros(length(eoma),1);
    for i  = 1 : length(eoma)
       eom_a(i,1) = eomdate(eoma(i,1)); 
    end
    eom_a_ = array2table([eoma],'VariableNames',{'DATEN'});

    eom_a_ = outerjoin(eom_a_,a,'Type','left','MergeKeys',true,'Keys','DATEN');
    eom_a_.DATEN =eom_a;

    
    
    %-------------------------
    eomb = get_date_in_month(b.DATEN,31);
    eom_b = zeros(length(eomb),1);
    for i  = 1 : length(eomb)
       eom_b(i,1) = eomdate(eomb(i,1)); 
    end
    eom_b_ = array2table([eomb],'VariableNames',{'DATEN'});

    eom_b_ = outerjoin(eom_b_,b,'Type','left','MergeKeys',true,'Keys','DATEN');
    eom_b_.DATEN =eom_b;


    c = outerjoin(eom_a_,eom_b_,'Type','left','MergeKeys',true,'Keys','DATEN');
    
    c_ = adj_table(table2array(c));

    c = array2table(c_,'VariableNames',c.Properties.VariableNames);
end