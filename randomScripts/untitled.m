clearvars, clc;

over = @(n,k) factorial(n) ./ (factorial(k).*factorial(n-k));

x = [0 1 3];
y = [1 2 3];

A = [x',ones(3,1)]

U = A'*A;
Y = A'*y'

a = U\Y