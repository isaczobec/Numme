function slope = derivative(f,x,dx)

slope = (f(x+dx) - f(x-dx))/(2*dx);

end