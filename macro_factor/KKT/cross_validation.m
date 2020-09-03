function p = cross_validation(bull,bear,data,fold)
% cross_validation 用来检验kkt基本面策略是否可行

    N = size(data,1);
    r = mod(N,fold);
    n = floor(N/fold);
    
    nums = ones(fold,1) * n;
    nums(1:r) = nums(1:r) + 1;
    
    idx = cumsum(nums);
    idx1 = idx - nums + 1;
   
    p = nan(size(data,1),1);
    for i=1:length(idx)
        bl_sample = true(size(data,1),1);
        bl_sample(idx1(i):idx(i)) = false;
        
        bl_bull = true(length(bull),1);
        bl_bear = true(length(bear),1);
        bl_bull(idx1(i):idx(i)) = false;
        bl_bear(idx1(i):idx(i)) = false;
        
        x = data(~bl_sample,:);
        sample = data(bl_sample,:);
        bull_sample = bull(bl_bull);
        bear_sample = bear(bl_bear);
        
        p(~bl_sample) = probability(x,sample,bull_sample,bear_sample);
        
    end

end

