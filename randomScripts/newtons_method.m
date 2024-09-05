function root = newtons_method(f,x0,num_iters,dfdx)
arguments
    f
    x0
    num_iters
    dfdx = @(x) derivative(f,x,0.001)
end
% NEWTONS_METHOD approximates a root for f(x) using newtons method

xi = x0;
for i = 1:num_iters
    xi = xi - (f(xi))./(dfdx(xi));
end

root = xi;

end