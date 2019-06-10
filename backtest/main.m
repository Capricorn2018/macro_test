clear all;
clc;

filename = 'D:/Projects/macro_test/国开债指数.xlsx';
[nav,ret,reb] = load_assets(filename,5,'last');