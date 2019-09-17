function  load_macro_data(d)

    z = readtable('indicator.xlsx','Sheet','full');
    w = windmatlab;w.menu;

    for i  = 1 : height(z)
       [y,~,~,t,~,~]= w.edb(cell2mat(z.ID(i)),'2000-01-01',datestr(today(),'yyyy-mm-dd'));
       x = array2table([t,y],'VariableNames',{'DATEN','VALUE'});
       save([d.macro_data_path ,'\',cell2mat(z.ID(i)),'.mat'],'x');
    end

end