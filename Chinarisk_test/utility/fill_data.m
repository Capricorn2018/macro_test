function m = fill_data(da, db,opt)
       %  a and b are tables,1st col is datenumber 最好 a 就全是datenumber
       %  table 2 must have 2 col
       %  a and b must have same VariableName called DATEN
       
       
       %  m   =  outerjoin(da,db,'Type','left','MergeKeys',true);

       %  idx_b 为 m 中为第3列中，第一个不为0的下标 
       
       %  opt = 0 : unchanged
       %  opt = 1 -->  cut 1：idx_a-1
       %  opt = 2 -->  cut 1：idx_b-1
       %  opt = 3 -->  cut 1：max(idx_a,idx_b)-1
       %  opt = 4 -->  cut 1：min(idx_a,idx_b)-1
           
       % test case
       % da =  array2table([(737000:737004)',[NaN,NaN,2,3,4]'],'VariableNames',{'DATEN','T1'});
       % db =  array2table([(737000:2:737004)',[1,2,3]'],'VariableNames',{'DATEN','T2'});
       %  m = fill_data(da, db,1)
       
       
       % da =  array2table([737000:737004]','VariableNames',{'DATEN'})
       % db =  array2table([(737000:2:737004)',[1,2,3]'],'VariableNames',{'DATEN','T2'})
       %  m = fill_data(da, db,1)
          
      z1 = da.Properties.VariableNames;
      z2 = db.Properties.VariableNames;
        
      m   =  outerjoin(da,db,'Type','left','MergeKeys',true,'Keys','DATEN');

      [d_b ,idx_b]  =  fill_singe_data(table2array(m(:,end)));
      m = array2table([table2array(m(:,1:end-1)),d_b],'VariableNames',[z1,z2(2)]);

      u  = 0;
      
      switch opt
%           case 0        
%           case 1
%           case 2
%               if idx_b >1 ,  u = idx_b - 1;  end
          case 3
              if max(1,idx_b)>1 , u =  max(1,idx_b) - 1; end
%           case 4
%               if min(1,idx_b)>1 , u =  min(1,idx_b) - 1; end
      end
 
      if u>0
           m(1:u,:) = [];
      end

      m   =  sortrows(m,'DATEN','ascend');
      
end

function [d,idx] = fill_singe_data(d)

      idx  = find(~isnan(d),1,'first');
      if ~isempty(idx) % 如果不空则要补数据 
          if idx>1   %补前面的
              d(1:idx-1) = d(idx);
          end
          idxx = ~isnan(d);
          vr   = d(idxx);
          d    = vr(cumsum(idxx));
      else    %补后面的
          idx = 0;
          idxx = ~isnan(d);
          vr   = d(idxx);
          d    = vr(cumsum(idxx));
      end

end