function x = back_substitution(A,b,start_from_bottom)
% solves Ax = b GIVEN THAT A is triangular

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

% flip matrix
if start_from_bottom
        A = flipud(fliplr(A));  % Flip A both upside down and left to right
        b = flipud(b);  % Flip b upside down
end

% we know A and b have compatible dimensions
row_indexes = 1:n;

% preallocate x array
x = zeros(n,1);

i = row_indexes(1,1);
x(i,1) = b(i,1)/A(i,1); % set the first variable
c = 1; % counter variable

for i = row_indexes(1,2:end)

    b(i,1) = b(i,1) - (A(i,1:c)*x(row_indexes(1,1:c),1));
    x(i,1) = b(i,1)/A(i,i);
    c = c + 1; % increment counter
end

% flip back x
if start_from_bottom
    x = flipud(x);
end