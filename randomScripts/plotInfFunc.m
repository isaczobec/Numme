clearvars, clc, close all

k = 4;
m = 1/16;

f = @(x,n) -4./(pi * (2*n-1).^2) .* cos((2*n-1).*x);

ns = [1,5,20,100];
num_funcs = length(ns);
funcs = cell(1,num_funcs);
for i = 1:num_funcs
    funcs{i} = infinite_sum_function(f,ns(i));
end

hold on;
xs = linspace(-10,10,10000);
ys = zeros(3,length(xs));
for j = 1:length(funcs)
    for i = 1:length(xs)
        ys(j,i) = funcs{j}(xs(i)) + pi/2;
    end
    plot(xs,ys(j,1:end)); 
end
