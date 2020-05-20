function [res,sat,sat_ma3chg,pmi_ma3chg,dt] = read_orig(start_dt,end_dt)

    w = windmatlab;
    
    [num,txt] = xlsread('original_data.xlsx');
    
    dt_str = txt(2:end,2);
    dt_num = nan(length(dt_str),1);
    
    for i = 1:length(dt_str)
        dt_num(i) = datenum(dt_str{i});
    end
    
    [dt,~,ic] = unique(dt_num);
    data = num(:,1);
    sat = nan(length(dt),1);
    
    for i = 1:length(dt)
        
        sat(i) = sum(data(ic==i));
        
    end
    
    [pmi,~,~,pmi_times,~,~] = w.edb('M0017126',start_dt,end_dt);
    
    [Lia,Locb] = ismember(dt,pmi_times);
    
    if any(~Lia)
        disp('error in read_orig');
        return;
    end
    
    tmp = nan(length(pmi),1);
    tmp(Locb) = sat(Lia);
    sat = tmp;
    
    dt = pmi_times;
    
    pmi_ma3chg = yr_abschg(ma3(pmi));
    sat_ma3chg = yr_chg(ma3(sat));
    
    bl = ~isnan(pmi_ma3chg) & ~isnan(sat_ma3chg);
    p = pmi_ma3chg(bl);
    s = sat_ma3chg(bl);
    
    p = p(1:40);
    s = s(1:40);
    
    mp = mean(p);
    stdp = std(p);
    
    ms = mean(s);
    stds = std(s);
    
    rho = corr(p,s);
    
    factor1 = (pmi_ma3chg - mp)/stdp;
    factor1(isnan(factor1)) = 0;
    
    factor2 = (sat_ma3chg - ms)/stds;
    factor2(isnan(factor2)) = 0;
    
    res = factor1 + factor2;
    
    bl = ~isnan(pmi_ma3chg) & ~isnan(sat_ma3chg);
    res(bl) = res(bl) / sqrt(2*(1+rho)) ;
    
    res(isnan(pmi_ma3chg) & isnan(sat_ma3chg)) = NaN;
    

end


% 移动平均3个月
function res = ma3(a)
    res = nan(length(a),1);
    for i = 3:length(a)
        res(i) = mean(a((i-2):i));
    end
end

function res = yr_chg(a)
    
    res = nan(length(a),1);
    for i = 13:length(a)
        res(i) = a(i)/a(i-12) - 1.;
    end

end

function res = yr_abschg(a)

    res = nan(length(a),1);
    for i = 13:length(a)
        res(i) = a(i) - a(i-12);
    end
    
end