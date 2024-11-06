clearvars, clc;

over = @(n,k) factorial(n) ./ (factorial(k).*factorial(n-k));