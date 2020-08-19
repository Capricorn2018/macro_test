function  u = get_dd_nav(z)
       % x是净值， y是基准， 都是累计收益 x和y都是N*1
       N = length(z);
       u = zeros(N,1);
       for i = 2:N
           u(i,1) = z(i,1)/max(z(1:i,1))-1;
       end
end