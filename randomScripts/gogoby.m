clearvars, clc, close all

[f_p,cs] = polynomial_interpolation(@(x) 2.178.^(-x.^2),[-3,3],8,true,1000)