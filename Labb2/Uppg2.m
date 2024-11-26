%% a)
clearvars; close all; clc;
% inför O = O1, O1' = O2 och bilda ett system

m=0.6;
L=1.5;
g=9.81;
u=0.2;

dydt = @(t,y) [
    y(2);
    -((u/m)*y(2)+(g/L)*sin(y(1)))
    ];

O0 = 0.5;
h = 0.025;
steps = 5/h;
vals_rk = RK4_system(dydt,[O0;0],0,h,steps);
vals_euler = eulers_method_system(dydt,[O0;0],0,h,steps);

euler_at_5 = vals_euler(2,end);
RK4_at_5 = vals_rk(2,end);

disp(['RK: value at t=5: ',num2str(RK4_at_5)])
disp(['Euler: value at t=5: ',num2str(euler_at_5)])

% plotta
figure(1);
hold on;
plot(vals_rk(1,1:end),vals_rk(2,1:end));
plot(vals_euler(1,1:end),vals_euler(2,1:end));
legend('RK4','Euler')

%% b) I 

clc;

des_err_euler = 10e-2 * 0.5;
des_err_RK4 = 10e-6 * 0.5;


euler_err = 99999;
% hitta steps för euler och rk
steps = 10;
while euler_err > des_err_euler
    hn = 5/steps;
    h2_vals = eulers_method_system(dydt,[O0;0],0,hn,steps);
    h_vals = eulers_method_system(dydt,[O0;0],0,hn / 2,steps * 2);
    euler_err = abs(h2_vals(2,end)-h_vals(2,end));
    steps = steps * 2;
end
disp(['Euler: took h = ',num2str(5/steps),' to reach error of ',num2str(des_err_euler)])

rk_err = 99999;
% hitta steps för euler och rk
steps = 10;
while rk_err > des_err_RK4
    hn = 5/steps;
    h2_vals = RK4_system(dydt,[O0;0],0,hn,steps);
    h_vals = RK4_system(dydt,[O0;0],0,hn / 2,steps * 2);
    rk_err = abs(h2_vals(2,end)-h_vals(2,end));
    steps = steps * 2;
end
disp(['RK4 : took h = ',num2str(5/steps),' to reach error of ',num2str(des_err_RK4)])


%% b) II


% beräkna precis referenslösning med h:et som krävdes för 10e-6 från förra
% sektionen

req_steps = 1310720;

RK4_vals = RK4_system(dydt,[O0;0],0,5/(req_steps),req_steps);
ans_at_5 = RK4_vals(2,end)

n = 17
init_steps = 5;
vec_ans = zeros(2,n);

steps = init_steps;
for i = 1:n
    h = 5/steps;
    eul = eulers_method_system(dydt,[O0;0],0,h,steps);
    rk = RK4_system(dydt,[O0;0],0,h,steps);
    vec_ans(1,i) = eul(2,end);
    vec_ans(2,i) = rk(2,end);
    steps = steps * 2;
end

errs = abs(vec_ans-ans_at_5);
upper = errs(1:end,1:end-1);
lower = errs(1:end,2:end);
ratios = upper./lower;
approx_noggranhet = log2(ratios);
% är 1 för euler, 4 för RK4 som förväntat!