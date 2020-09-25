function [dnum,npv] = load_value(filename)
    value = readtable(filename);

    d = value.dates;
    dnum = nan(length(d),1);

    for i=1:length(d)
        dnum(i) = datenum(num2str(d(i)),'yyyymmdd');
    end

    npv = value.nav;
end