function output_table = q_table( conn,q)
   
    curs =  fetch(exec(conn,q));   
    x = strsplit(curs.columnnames,{',',''''});
    y = x(2:end-1);
    [~,z] = ismember(unique(y),y);
    if ~strcmp(curs.Data, 'No Data')
      output_table  = cell2table( curs.Data(:,z),'VariableNames',y(:,z));
    else
       output_table = [];
      % output_table  = cell2table( cell( size(y(:,z))));
      % output_table.Properties.VariableNames =  y(:,z);
    end
    

end

