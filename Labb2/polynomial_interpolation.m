function [p,cs] = polynomial_interpolation(xs,ys)

n = length(xs);

x_mat = (ones(n,1) * xs)';
x_mat_poly = x_mat.^(ones(n,1) * (0:n-1));
cs = (x_mat_poly\(ys'))';

p = @(x) sum((x(:) .^ (0:n-1)) .* cs, 2)';

end