
time_per_customer_served = 0.2;
time_per_customer_arrived = 0.01;


dydt = @(t,y) time_per_customer_arrived - time_per_customer_served;

time = 1;
steps = 1000;

vals = RK4(dydt,8.5,0,time/steps,steps);



figure(1);
hold on;
plot(vals(1,1:end),vals(2,1:end));
