clearvars; clc;
y = [2100 1750 2250 1950 1500 1450];
x = [2000 1650 2100 1800 1550 1350];
n = length(x);

delta = y-x;
mu_delta = mean(delta);

s = sqrt(1/(n-1) * sum((delta-mu_delta).^2))

mu_delta - s/sqrt(n) * 2.015