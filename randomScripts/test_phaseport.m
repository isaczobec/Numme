

u = 0.25;
dxdt = @(x,y) y;
dydt = @(x,y) u*y - u*x.^3-x;

plot_phase_portrait(dxdt,dydt,0.1,10,[-4,4],[-4,4],[30,30])