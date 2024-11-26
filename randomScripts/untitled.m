clearvars, clc;

over = @(n,k) factorial(n) ./ (factorial(k).*factorial(n-k));

x = [0.4 0.7 1.0 1.2 1.4 1.7 2.0];
y = [0.23 0.34 0.42 0.55 0.61 0.77 0.84];

x_m = mean(x);
y_m = mean(y);

Sxx = sum((x - x_m).^2);
Sxy = sum((x - x_m).*(y - y_m));
Syy = sum((y - y_m).^2);

B = Sxy/Sxx;
A = y_m - B*x_m;

skatt = @(x) A + B*x;
std = @(x,x_m,Sxx,n) sqrt(1/n + (x-x_m)^2 / Sxx);

skatt(0)
std(0,x_m,Sxx,7)

Q0 = Syy - Sxy^2/Sxx
std = sqrt(Q0/(5))