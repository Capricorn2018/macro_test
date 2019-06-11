assets_file = 'D:/Projects/macro_test/国开债指数.xlsx';
[nav,ret,reb] = load_assets(assets_file,5,'last');

factor_file = 'D:/Projects/macro_test/国债期限利差.xls';
factor = load_factor(factor_file,reb,'sprd51');

tbl = merge_xy(factor, ret);

factor_file = 'D:/Projects/macro_test/凸度.xls';
factor = load_factor(factor_file,reb,'curv1510');

tbl = merge_xy(factor, tbl);

r1 = tbl.CBA02521;
r5 = tbl.CBA02531;
r10 = tbl.CBA02551;

mom1 = r10 - r1;
mom1 = [NaN;mom1(1:end-1)];

sprd51 = tbl.mean_sprd51;

curv1510 = tbl.mean_curv1510;