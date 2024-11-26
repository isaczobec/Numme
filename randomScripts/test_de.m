
f = @(t,y) -5*y;

a = eulers_method(f,10,0,0.1,100);

plot(a(1,1:end),a(2,1:end))