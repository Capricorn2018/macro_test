function  z = get_cum_exces_nav(x,y)
       % x�Ǿ�ֵ�� y�ǻ�׼�� �����ۼ����� x��y����N*1
       N = length(x);
       z = ones(N,1);
       for i = 2:N
           z(i,1) = z(i-1,1)*(1+ x(i,1)/x(i-1,1) - y(i,1)/y(i-1,1));
       end
end