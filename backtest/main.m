assets_file = 'D:/Projects/macro_test/����ծָ��.xlsx';
[nav,ret,reb] = load_assets(assets_file,5,'last');

factor_file = 'D:/Projects/macro_test/��ծ��������.xls';
factor = load_factor(factor_file,reb);

tbl = merge_xy(factor, ret);





