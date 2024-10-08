clearvars, clc, close all

dxdt = @(x,y) y.^2;
dydt = @(x,y) x.^2;

figure(1)
plot_phase_portrait(dxdt,dydt,0.01,5,[-10,10],[-10,10],[5,5])
