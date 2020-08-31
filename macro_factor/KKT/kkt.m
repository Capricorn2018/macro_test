function prob = kkt(x,mu1,mu2,sigma1,sigma2)
% 用马氏距离计算上升下降的概率

    inv_sigma1 = inv(sigma1);
    inv_sigma2 = inv(sigma2);

    x = trans(x);
    mu1 = trans(mu1);
    mu2 = trans(mu2);
    sigma1 = trans(sigma1);
    sigma2 = trans(sigma2);

    d1 = (x - mu1)' * inv_sigma1 * (x - mu1); %#ok<MINV>
    d2 = (x - mu2)' * inv_sigma2 * (x - mu2); %#ok<MINV>

    ld1 = 1/sqrt(det(2*pi*sigma1)) * exp( -d1 / 2);
    ld2 = 1/sqrt(det(2*pi*sigma2)) * exp( -d2 / 2);

    prob = ld1 / (ld1 + ld2);
    
end


function x = trans(x)
    if size(x,1)==1
        x = x';
    end
end

