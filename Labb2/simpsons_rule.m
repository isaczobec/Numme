function [I,E] = simpsons_rule(f,m,a,b)
% returns the definite integral I between (a,b) and the error term E (without the f''''(c) factor)
% given a function f(x) and m panels
arguments
    f
    m
    a
    b
end

h = (b-a)/2/m;

xs = linspace(a,b,2*m+1);
odd_sum = 4 * sum(f(xs(2:2:end)));
even_sum = 2 * sum(f(xs(3:2:end-1)));

y0 = f(xs(1));
y2m = f(xs(end));

I = h/3 * (odd_sum + even_sum + y0 + y2m);

E = -(b-a)*h^4 / 180;


end