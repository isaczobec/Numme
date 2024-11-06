clearvars; close all; clc;

dydt = @(t,y) 1 - 2*y;
y0 = 0;
t0 = 0;
h = 0.01;
steps = 1000;

y = @(t) -1/2 * exp(1).^(-2*t) + 1/2;



vals_RK4 = RK4(dydt,y0,t0,h,steps);
vals_euler = eulers_method(dydt,y0,t0,h,steps);

ts = linspace(t0,t0+steps*h,steps);
ys = y(ts);

figure(1);
hold on;
plot(vals_RK4(1,1:end),vals_RK4(2,1:end),'b');
plot(vals_euler(1,1:end),vals_euler(2,1:end),'r');
plot(ts,ys,'g');
legend('RK4','Euler','function');
title(1,'RK4 vs Euler vs function');


error = abs(vals_RK4(2,1:end) - ys);
figure(2);
plot(ts,error,'r');
title(2,'Error')