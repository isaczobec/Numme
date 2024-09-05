function x = solve_linear_equation_matrix(A,b)
% Solves the equation Ax = b, given that A is a N * N matrix and x is a vector with N elements 

n = height(A);
% check if initial conditions are correct
if n ~= width(A)
    error("A is not square!")
end
if n ~= height(b)
    if n == width(b)
        b = b';
    else
        error("x is not the same dimensions as A!")
    end

end

% dimensions of A and x are compatible if this code is reached

% LU factorization
[L,U] = LU_factor(A);
y = back_substitution(L,b,false);
z = back_substitution(U,y,true);

x = z;


end