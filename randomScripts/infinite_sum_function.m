function fN = infinite_sum_function(f,max_n)
arguments
    f
    max_n {mustBeNumeric} = 100
end
% Returns a function handle that approximates an infinite sum of f(x,n)
% f must be a scalar function handle taking (x,n) as inputs, and work with
% elemet-wise vector operations.

ns = 1:max_n;
fN = @(x) sum(f(ones(1,max_n)*x,ns));

end