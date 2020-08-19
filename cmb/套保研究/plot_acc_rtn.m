function   plot_acc_rtn(s1,s2,v)

    % s1 s2  = [DATENUM, CUM_NAV]
    % s2 为基准

    [~,ia,ib] = intersect(s1(:,1),s2(:,1));
    s = [s1(ia,:),s2(ib,2)];
    s(:,2) = s(:,2)/s(1,2);
    s(:,3) = s(:,3)/s(1,3);

    subplot(4,1,[1,2])
    plot(s(:,1),s(:,2),'r','LineWidth',2); hold on;
    plot(s(:,1),s(:,3),'k','LineWidth',1); hold on;
    datetick('x','yyyy','keeplimits')
    legend(v{1},v{2},'Location','northwest')
    legend('boxoff')
    axis tight

    subplot(4,1,3)
    z = get_cum_exces_nav(s(:,2),s(:,3));
    plot(s(:,1),z,'k','LineWidth',1); hold on;
    datetick('x','yyyy','keeplimits')
    legend('累计超额收益','Location','northwest')
    legend('boxoff')
    axis tight

    subplot(4,1,4)
    u = get_dd_nav(z);
    area(s(:,1),u); hold on;
    datetick('x','yyyy','keeplimits')
    legend('超额收益回撤','Location','south')
    legend('boxoff')
    grid on
    axis tight

end