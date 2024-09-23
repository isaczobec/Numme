clearvars;clc

F = @(x) [2*x(1),2*x(2)]';

root = gradient_descent([100,10]',F,0.1,100)