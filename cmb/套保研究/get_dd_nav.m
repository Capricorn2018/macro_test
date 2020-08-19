function  u = get_dd_nav(z)
       % x�Ǿ�ֵ�� y�ǻ�׼�� �����ۼ����� x��y����N*1
       N = length(z);
       u = zeros(N,1);
       for i = 2:N
           u(i,1) = z(i,1)/max(z(1:i,1))-1;
       end
end