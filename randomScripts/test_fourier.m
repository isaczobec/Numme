clearvars, clc, close all

f = @(x,n) (((-(-1).^n).*(2*n)-2*n)/(1-n.^2)/pi).*sin(n.*x)


fourier_f = infinite_sum_function(f,3);

am_sums = [128,12];
n_sums = length(am_sums);
funcs = cell(1,n_sums);

% populate functions
for i = 1:n_sums
    funcs{i} = infinite_sum_function(f,am_sums(i));
end

n = 10000;
xs = linspace(-10,10,n);
ys = zeros(n_sums,n);
for j = 1:n_sums
    for i = 1:n
        ys(j,i) = funcs{j}(xs(i));
    end
end

plot(xs,ys);

