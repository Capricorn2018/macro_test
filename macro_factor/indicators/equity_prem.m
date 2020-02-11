function [res,times] = equity_prem(start_dt,end_dt)
% equity_prem计算equity premium

    w = windmatlab;

    % 沪深300, 中证500, 中证红利
    [pe,~,~,pe_times,~,~] = w.wsd('399300.SZ,000905.SH,000922.CSI','pe_ttm',start_dt,end_dt);

    % 国债10年
    [yield,~,~,yield_times,~,~] = w.edb('M1004271',start_dt,end_dt);
    
    [times,ia,ib] = intersect(pe_times,yield_times);
    
    pe = pe(ia,:);
    yield = yield(ib,:);
    
    pe300_yield = pe(:,1) - yield;
    pe500_yield = pe(:,2) - yield;
    peDY_yield = pe(:,3) - yield;
    
    res = pe - yield;
    
    figure(2);
    subplot(3,2,1);
    plot_hist(pe300_yield);
    title('CSI300 PE minus BOND10Y histogram');
    subplot(3,2,2);
    plot(times,pe300_yield);
    datetick('x','yyyy','keeplimits');
    title('CSI300 PE minus BOND10Y');
    axis tight;
    subplot(3,2,3);
    plot_hist(pe500_yield);
    title('CSI500 PE minus BOND10Y histogram');
    subplot(3,2,4);
    plot(times,pe500_yield);
    datetick('x','yyyy','keeplimits');
    title('CSI500 PE minus BOND10Y');
    axis tight;
    subplot(3,2,5);
    plot_hist(peDY_yield);
    title('CSI Dividend PE minus BOND10Y histogram');
    subplot(3,2,6);
    plot(times,peDY_yield);
    datetick('x','yyyy','keeplimits');
    title('CSI Dividend PE minus BOND10Y');
    axis tight;

    w.close;
    
end

