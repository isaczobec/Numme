clearvars, clc;

over = @(n,k) factorial(n) ./ (factorial(k).*factorial(n-k));

sum = 0;
for i = 8:10
    sum = sum + over(10,i) * (1/2)^10
end

sum