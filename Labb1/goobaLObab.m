clearvars;clc

syms x y z

f(x,y,z) = x^2 + y + z;

gradient(f)
g = ans'

g(2,1,1)