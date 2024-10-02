clearvars;clc

F = @(x) [2*x(1),2*x(2)]';

root = gradient_descent([100,10]',F,0.1,100)

u = 1
t = 10^100

bu = 10^80 + t
cmakn = bu - t