assets_file = 'D:/Projects/macro_test/国开债指数.xlsx';
[nav,ret,reb] = load_assets(assets_file,5,'last');

factor_file = 'D:/Projects/macro_test/国债期限利差.xls';
factor = load_factor(factor_file,reb);

tbl = merge_xy(factor, ret);





