function make_plots(x,d,p)
   %  x 1st col: datenumber   2nd  col : pirce
   % e.g. x =   [731584, 1;
%                731587, 1.001;
%                731588, 1.002;
%                731589, 1.005;
%                ...;
%                731590, 1.02]

   [MaxDD, MaxDDIndex] = maxdrawdown(x(:,2));
    [r,z] = deal(zeros(size(x,1),1));
    for i = 2:size(x,1)
           c = max(x(1:i,2));
        if c == x(i,2)
           r(i) = 0;
        else
           r(i) = (x(i,2)-c)/c;
        end
    end

    u =  max(x(:,2)) - min(x(:,2));
    z(MaxDDIndex(1):MaxDDIndex(2)) = max(x(:,2))+0.1*u;
    zz = figure;
    subplot(4,1,1:3)
    h = area(x(:,1),z,'LineStyle','none');
    datetick('x','yy','keeplimits')
    h(1).FaceColor = [1,0.5,0];
    h(1).EdgeColor = 'none';
    h(1).EdgeAlpha = 0;
    h(1).FaceAlpha = 0.2;
    ylim([min(x(:,2))-0.1*u, max(x(:,2))+0.1*u])
    xlim([x(1,1),x(end,1)])
    hold on
    plot(x(:,1),x(:,2));

    subplot(4,1,4)
    area(x(:,1),r);
    datetick('x','yy','keeplimits')
    xlim([x(1,1),x(end,1)])
    grid on
     saveas(zz,[d.graph_path ,'\rp_',num2str(p.tgt_vol*100),'.bmp']);
    zz.delete
end