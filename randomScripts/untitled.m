clearvars, clc;

over = @(n,k) factorial(n) ./ (factorial(k).*factorial(n-k));


w = [0.6,0.1,0.2,0.05,0.05];
x = 0:4;
u = 0.85;

(x - u).^2.*w