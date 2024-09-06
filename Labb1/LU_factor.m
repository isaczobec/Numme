function [L,U] = LU_factor(A)


n = height(A);
% check if initial conditions are correct
if n ~= width(A)
    error("A is not square!")
end

% LU factorisation
L = eye(n,n); % create L
% A is an n*n matrix
for j = 1:n-1
    for i = j+1:n
        fac = A(i,j) / A(j,j);
        L(i,j) = fac;
        A(i,1:end) = A(i,1:end) - A(j,1:end) * fac;
    end
end

U = A;

end