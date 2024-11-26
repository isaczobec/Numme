function [I,E] = trapezoid_rule(f,m,a,b)
% returns the definite integral I between (a,b) and the error term E (without the f''(c) factor)
% given a function f(x) and m panels
arguments
    f
    m
    a
    b
end

h = (b-a)/m;

xs = linspace(a,b,m+1);
overlap_panels = 2 * sum(f(xs(2:end-1)));

y0 = f(xs(1));
ym = f(xs(end));

I = h/2 * (overlap_panels + y0 + ym);

E = -(b-a)*h^2 / 12;


end