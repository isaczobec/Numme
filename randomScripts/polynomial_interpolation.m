function [f_poly,cs] = polynomial_interpolation(f,interval,n,plot_functions,plot_points)
arguments
    f
    interval
    n
    plot_functions = true
    plot_points = 100
end
% returns a funciton handle for a polynomial function of degree n-1
% interpolated to fit f(x) on the interval [a,b]. n is the amount of points
% in the interpolation.

int_len = interval(2)-interval(1);
xs = ((0:n-1)*int_len/(n-1) + interval(1));
xs_mat = xs'*ones(1,n);
ys = f(xs');

exponents = ones(1,n)'*(0:n-1);


A = xs_mat.^exponents;
cs = A\ys;

(exponents(1,1:width(exponents))'*ones(1,6));
f_poly = @(x) sum(((ones(n,1)*x).^(exponents(1,1:width(exponents))'*ones(1,length(x)))).*(cs*ones(1,length(x))));

if plot_functions
    p_xs = linspace(interval(1),interval(2),plot_points);
    p_ys_func = f(p_xs);
    p_ys_poly = f_poly(p_xs);
    hold on;
    plot(p_xs,p_ys_func,'b');
    plot(p_xs,p_ys_poly,'r');
    legend('original function','interpolated polynomial');
end