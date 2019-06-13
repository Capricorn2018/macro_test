assets_file = 'D:/Projects/macro_test/国开债指数.xlsx';
[nav,ret,reb] = load_assets(assets_file,5,'last');

factor_file = 'D:/Projects/macro_test/国债期限利差.xls';
factor = load_factor(factor_file,reb,'sprd51');

tbl = merge_xy(factor, ret);

factor_file = 'D:/Projects/macro_test/凸度.xls';
factor = load_factor(factor_file,reb,'curv1510');

tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/凸度30.xls';
factor = load_factor(factor_file,reb,'curv11030');

tbl = merge_xy(factor, tbl);

factor_file = 'D:/Projects/macro_test/国开利差.xls';
factor = load_factor(factor_file,reb,'sprdfin');

tbl = merge_xy(factor, tbl);

% 截取2005年以后的数据
tbl_orig = tbl;
tbl = tbl(year(tbl.date)>=2005,:);

r0 = tbl.CBA02511;
r1 = tbl.CBA02521;
r5 = tbl.CBA02531;
r10 = tbl.CBA02551;

mom1 = r10 - r1;
mom1 = [NaN;mom1(1:end-1)];

sprd51 = tbl.mean_sprd51;
sprdfin = tbl.mean_sprdfin;

curv1510 = tbl.mean_curv1510;
curv11030 = tbl.mean_curv11030;
