function prob = kkt(x,mu1,mu2,sigma1,sigma2)
% 用马氏距离计算上升下降的概率

    inv_sigma1 = 1\sigma1;
    inv_sigma2 = 1\sigma2;

    x; % 变量

    d1 = (x - mu1)' * inv_sigma1 * (x - mu1);
    d2 = (x - mu2)' * inv_sigma2 * (x - mu2);

    ld1 = 1/sqrt(det(2*pi*sigma1)) * exp( -d1 / 2);
    ld2 = 1/sqrt(det(2*pi*sigma2)) * exp( -d2 / 2);

    prob = ld1 / (ld1 + ld2);
    
end

