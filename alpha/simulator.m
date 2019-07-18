%%%%%% ע��ʾ�� %%%%%%
% all_dates = [datenum(2018,1,1):datenum(2018,12,1)]';
% secs = {'stk1','stk2','stk3','stk4'};
% rtn_table   = array2table  ( [ all_dates,randn(length(all_dates),4)],'VariableNames',['DATEN',secs]);
% 
% w = [[0.2,0.3,0.1,0];[0.5,-0.1,-0.2,0.2]];
% weight_table  = array2table  ( [ all_dates([1,11]),w],'VariableNames',['DATEN',secs]);
% 
% cost_table  = array2table  ( [ all_dates([1,11]),zeros(2,4)],'VariableNames',['DATEN',secs]);
% 
% [simulated_nav,weight] = simulator(rtn_table,weight_table,cost_table)

function [simulated_nav,weight] = simulator(rtn_table,weight_table,cost_table)
   
       % rtn_table     [all_dates, returns]
       % weight_table  [reblance_dates, weight]
       % cost_table    [reblance_dates, cost]

       %  first to check  reblance dates belongs to all trading dates      
       idx_d = ismember(weight_table.DATEN,rtn_table.DATEN);
       weight_table = weight_table(idx_d,:); 
       cost_table   = cost_table(idx_d,:);
       
       %  Then to remove dates in rtn_table that before the first re date
     %  rtn_table = rtn_table(rtn_table.DATEN>=weight_table.DATEN(1),:);
       
       rtn_array     = table2array(rtn_table(:,2:end));
       rtn_array(isnan(rtn_array)) = 0;
       w              = table2array(weight_table(:,2:end));
       trans_cost     = table2array(cost_table(:,2:end));
       
       reblance_dates      = weight_table.DATEN;
       model_trading_dates = rtn_table.DATEN;
       
       T = size(rtn_table,1);     % number of trading dates
       N = size(rtn_table,2) - 1;      % number of assets 
       W = length(reblance_dates); % number of reblance dates
              
       simulated_nav    =  ones(T,1);
       transaction_cost = zeros(W,1); % cost occured at each    rebalance date 
       weights = zeros(T,N+1);  % last col is the cash portion

       for i  = 1:W
         %  disp(i)
              idx_this = find(reblance_dates(i)  == model_trading_dates,1,'first');
              if  i~=W
                 idx_next = find(reblance_dates(i+1)== model_trading_dates,1,'first');
              else
                 idx_next = find(model_trading_dates(end)== model_trading_dates,1,'first'); 
              end
              %  ����������һ�����裬ÿ�ε��ֵĳɱ����� sum (��i����Ʊ�����ֵ���ֵ*costi) �������£�
              %  ����һ���򵥵��������ȫ��A��Ʊ����Ȼ�󻻳�B��Ʊ, ��ôʵ�ʵĽ��׳ɱ�Ӧ����: ����A�ĳɱ� + ����B�ĳɱ���
              %  ��������ǳ���ɱ�����ô����A�ĳɱ� = A��������ֵ * costA�� ����B�ĳɱ� =  [A��������ֵ*(1 - costA)]*(costB) 
              %  ����ܵĽ��׳ɱ��� A��������ֵ*(costA + costB - costA*costB)~=  A��������ֵ*(costA + costB)�����˵��ʵ���ϵ͹���һ���߽��              
              if i==1
                 tmp_nav_last = zeros(1,N+1);
              end
              
              tmp_nav_this = zeros(idx_next-idx_this+1,N+1);  % �����ֽ��˻�
              
              o = simulated_nav(idx_this,:)*w(i,:) - tmp_nav_last(end,1:N);
              c = nansum(abs(o).*trans_cost(i,:)); % ����ʱʵ�ʻ��˶���Ǯ,�����и����裬�ٶ�ÿ�ε��ֺ󣬸����ʲ���Ȩ��ֱ�ӴﵽĿ���λ��cost�������ֽ��˻�
                                                                                                            % �����������ֵ�������ֽ��˻�ʵ���Ͼ��Ǹ���          
              if simulated_nav(idx_this,:)*(1- nansum(w(i,:)))-c >0
                 tmp_nav_this(1,:) =  [simulated_nav(idx_this,:)*w(i,:),simulated_nav(idx_this,:)*(1- nansum(w(i,:)))-c];  % ÿ���ʲ���ʵ��Ͷ���˶���Ǯ���ֽ��˻������ж���Ǯ
              else
                 tmp_nav_this(1,:) =  [simulated_nav(idx_this,:)*w(i,:)- c*w(i,:)/nansum(w(i,:)),simulated_nav(idx_this,:)*(1- nansum(w(i,:)))]; 
              end
              transaction_cost(i,1) = nansum(abs((simulated_nav(idx_this,:)*w(i,:) - tmp_nav_last(end,1:N)))) /simulated_nav(idx_this,:); % ���㻻����
              if size(tmp_nav_this,1)>1
                 for j = 2 : size(tmp_nav_this,1)
                     t  = rtn_array(idx_this+j-1,:);
                     tmp_nav_this(j,1:N) =   tmp_nav_this(j-1,1:N).*(1+t);
                     tmp_nav_this(j,N+1) =   tmp_nav_this(j-1,N+1);
                 end
              end
%               simulated_nav(idx_this,:) =   simulated_nav(idx_this,:) -c;
%               simulated_nav(idx_this+1:idx_next,:) = nansum(tmp_nav_this(2:end,:),2);             
              simulated_nav(idx_this:idx_next) = nansum(tmp_nav_this,2);
              
              weights(idx_this:idx_next,:) = tmp_nav_this./repmat(sum(tmp_nav_this,2),1,size(tmp_nav_this,2)) ;
              tmp_nav_last = tmp_nav_this;   clear tmp_nav_this;              
       end
       
       simulated_nav = array2table([model_trading_dates,simulated_nav],'VariableNames',{'DATEN','NAV'});
       
       %weights = weights./repmat(sum(weights,2),1,size(weights,2));
       weight = array2table([model_trading_dates,weights],'VariableNames',[rtn_table.Properties.VariableNames,'Cash']);
       
end

