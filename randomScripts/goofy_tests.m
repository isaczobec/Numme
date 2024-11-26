clearvars;clc;close all;
f = @(x) ((x-1).^2 + 1);
g = @(x) ((x-2).^2 / 2 + 1/2);

function [r,graph] = fpi(f,x0,iters,known_fixpoint)
    
    graph = zeros(2,iters);
    xi = x0;
    for i = 1:iters
        graph(1,i) = abs(known_fixpoint - xi);
        graph(2,i) = i;
        xi = f(xi);
    end
    r = xi;
end

[r,graph] = fpi(f,0.9,1000,1);

plot(graph(2,1:end),graph(1,1:end))