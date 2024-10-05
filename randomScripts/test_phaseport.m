

dxdt = @(x,y) 0;
dydt = @(x,y) y.*(y-3*y+y.^2).^2;

plot_phase_portrait(dxdt,dydt,0.1,100,[-10,10],[-10,10],[10,10])