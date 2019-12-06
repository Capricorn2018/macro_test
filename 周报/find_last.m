function y = find_last(x)

    nums = x(~isnan(x));
    if(~isempty(nums))
        y = nums(end);
    else
        y = NaN;
    end

end

