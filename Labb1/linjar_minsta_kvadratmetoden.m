function [f_anpassad,x] = linjar_minsta_kvadratmetoden(A,b,f)
% tar matris A, vektor b, en funktion f(t,x) (linjär i x) där x är en vektor med parametrar som ska
% bestämmas av mkm. returnerar funktion med instoppade parametrar.
arguments
    A
    b
    f
end

VL = A'*A;
HL = A'*b;
x = HL\VL;
f_anpassad = @(t) f(t,x);


end