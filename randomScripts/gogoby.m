clearvars, clc, close all

c = 1/4;
cs = [1/4,4,0,-9];

dxdt = @(x,y) -x + y;
dydt = @(x,y) c*x - y;

for i = 1:length(cs)
c = cs(i);
dxdt = @(x,y) -x + y;
dydt = @(x,y) c*x - y;
figure(i)
plot_phase_portrait(dxdt,dydt,0.1,400,[-10,10],[-10,10],[5,5])
end