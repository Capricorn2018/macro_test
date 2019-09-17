function [simulated_nav,allocation,allocation_detail,stats] =  get_tgt_vol_portfolio(d,p,s)

   [nav_eqt,   weight_eqt,   w_eqt,...
    nav_fi,    weight_fi,    w_fi,...
    nav_comdty,weight_comdty,w_comdty,... 
    nav,       weight_risky, w            ] = get_risky_and_unrisky_assets_portfolio(d,p);
      
    u = [nav_fi.NAV,nav.NAV];
    
    input_table = array2table([nav_fi.DATEN,[zeros(1,2);price2ret(u,[],'Periodic')]],'VariableNames',{'DATEN','FI','RISKY'});
    [simulated_nav,weight]  = bulid_tg_index(p,input_table);
   
    wtable = zeros(height(simulated_nav),size(weight_eqt,2)-1);

    eqt_w     = weight.RISKY.*weight_risky.EQT;
    comdty_w  = weight.RISKY.*weight_risky.COMDTY;
    fi_w      = weight.FI;
    
    allocation = array2table([simulated_nav.DATEN,eqt_w,comdty_w,fi_w,1-eqt_w-comdty_w-fi_w],'VariableNames',{'DATEN','EQT','COMDTY','FI','CASH'});
    
    [~,id_eqt]    = ismember(p.selected_eqt,   p.selected);
    [~,id_fi]     = ismember(p.selected_fi,    p.selected);
    [~,id_comdty] = ismember(p.selected_comdty,p.selected);
    
    x = table2array(weight_eqt(:,2:end));
    wtable(:,id_eqt) = repmat(eqt_w,1,length(id_eqt)).* x(:,id_eqt); clear x;
    
    x = table2array(weight_fi(:,2:end));
    wtable(:,id_fi) = repmat(fi_w,1,length(id_fi)).* x(:,id_fi); clear x;
    
   x = table2array(weight_comdty(:,2:end));
    wtable(:,id_comdty) = repmat(comdty_w,1,length(id_comdty)).* x(:,id_comdty); clear x;
    
    wtable(:,end) = 1 - sum(wtable(:,1:end-1),2);
    
    allocation_detail = array2table([simulated_nav.DATEN,wtable],'VariableNames',weight_eqt.Properties.VariableNames);
    
    
    simulated_nav = simulated_nav(simulated_nav.DATEN>=s,:);
    simulated_nav.NAV = simulated_nav.NAV./simulated_nav.NAV(1);
    allocation  = allocation(allocation.DATEN>=s,:);
    allocation_detail  = allocation_detail(allocation_detail.DATEN>=s,:);
          
     ret_strategy =  power(simulated_nav.NAV(end)/simulated_nav.NAV(1),365/(simulated_nav.DATEN(end)-simulated_nav.DATEN(1)))-1;
     vol_strategy =  std(price2ret(simulated_nav.NAV,[],'Periodic'))*sqrt(250);
     maxDD_strategy = maxdrawdown(simulated_nav.NAV);
     stats = [p.tgt_vol,ret_strategy,vol_strategy,ret_strategy/vol_strategy,maxDD_strategy];
end