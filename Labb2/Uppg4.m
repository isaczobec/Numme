%% a) I 
close all; clearvars; clc

% parametrar
k1 = 0.004;
k2 = 0.078;
g = 9.81;
v0 = 18.5;
h0 = 0.50;
m = 0.75;

% y(1) är x-pos, y(2) är y-pos, y(3) är x-hast, y(4) är y-hast
% skriv upp systemet:
f = @(t,y) [...    
    y(3);...
    y(4);...
    -(k1*y(3))*sqrt(y(4).^2+y(3).^2)/m;...
    -(k2*y(4))*sqrt(y(4).^2+y(3).^2)/m - g;
    ];

% beräkna y0:
a0 = pi/4;
y0 = [0;h0;cos(a0)*v0;sin(a0)*v0];

% skapa lokal funktion som löser systemet
function [trajectory,...
    hit_x,...
    ground_indicies, ...
    spline_func, ...
    spline_func_der] = trajectory_calculation(h,steps,f,y0)
    % lös systemet

    trajectory = RK4_system(f,y0,0,h,steps);
    
    % hitta punkter nära y = 0
    signs = trajectory(3,1:end-1) .* trajectory(3,2:end);
    ground_index = find(signs<0,1,"first");
    ground_indicies = ground_index-1:ground_index+2; % välj 4 närliggande punkter
    % interpolera punkter och hitta derivata
    [spline_func,cs] = polynomial_interpolation(trajectory(2,ground_indicies),trajectory(3,ground_indicies));
    spline_func_der = @(x) sum((1:length(cs)-1) .* cs(2:end) .* x.^(0:(length(cs)-2)));
    % hitta punkt s.a y = 0 m. newtons metod
    hit_x = newtons_method(spline_func,trajectory(2,ground_index),100,spline_func_der,10^-10);
    % hit_x = bisection_method(spline_func,trajectory(2,ground_indicies(1)),trajectory(2,ground_indicies(end)),10^-10,1000);

end

% kör funktionen tills feldifferensen blir liten
h = 0.16;
steps = 17;

max_iters = 10;
ans_vec = zeros(1,max_iters+1);
ans_vec(1) = 99999999999;
err_diff = 999999; % godtyckligt hög
max_err = 10^-6;
for i = 2:max_iters+1
    [trajectory,hit_x,ground_indicies,spline_func,spline_func_der] = trajectory_calculation(h,steps,f,y0);
    ans_vec(i) = hit_x;
    err_diff = abs(ans_vec(i-1)-ans_vec(i));
    if err_diff < max_err
        disp(['error of hit point ',num2str(max_err),' reached with h = :',num2str(h)])
        break
    end
    % ändra h och steps
    h = h / 2;
    steps = steps * 2;
end

hit_x

% plotta
figure(1);
title(1,'Trajectory over time')
hold on;
plot(trajectory(2,1:end),trajectory(3,1:end),'.');
plot([0,25],[0,0]);
plot(linspace(trajectory(2,ground_indicies(1)),trajectory(2,ground_indicies(end)),100),...
    spline_func(linspace(trajectory(2,ground_indicies(1)),trajectory(2,ground_indicies(end)),100)))
legend('Trajectory','Ground','cubic interpolation')

%% b)
clc;

% använd sekantmetoden för att hitta två st. a0 s.a x = 20
% gissningar vinkeln betecknas ai, nedslagspunkten i x xi

h = 0.16;
tolerance = 0.1;

h_steps = 10;
tol_steps = 10;

ans_mat = zeros(h_steps,tol_steps);

for hi = 1:h_steps
for ti = 1:tol_steps

    a0 = pi/4; % i förra uppgiften givna startvinkel, gav x =~ 23
    a1 = pi/4*0.9; % gissa lite annan vinkel
    [t,x0] = trajectory_calculation(0.02,150,f,[0;h0;cos(a0)*v0;sin(a0)*v0]);
    [t,x1] = trajectory_calculation(0.02,150,f,[0;h0;cos(a1)*v0;sin(a1)*v0]);
    
    ai = a0;
    aip = a1;
    xi = x1;
    xip = x0;
    for i = 1:10
    
        ainew = ai - (xi-20) * (ai - aip) / (xi - xip);
        [t,xinew] = trajectory_calculation(0.02,150,f,[0;h0;cos(ainew)*v0;sin(ainew)*v0]);
    
        aip = ai;
        xip = xi;
        ai = ainew;
        xi = xinew;
        
        % avsluta om nått toleransnivå
        if abs(xinew-20) < tolerance
            break
        end
    
    end

    ans_mat(hi,ti) = ai;

    % inkrementera parametrar
    tolerance = tolerance/2;
end
    h = h / 2;
end

% spara roten och banan
root_a_1 = ai;
x_1 = xi;
traj_1 = t;

% kolla felgränser över både h och toleransen:
h_diff = abs(ans_mat(1:end-1,:)-ans_mat(2:end,:));
tol_diff = abs(ans_mat(:,1:end-1)-ans_mat(:,2:end));


% HITTA DEN ANDRA LÖSNINGEN FÖR ALPHA:
a0 = pi/4; % i förra uppgiften givna startvinkel, gav x =~ 18
a1 = pi/3; % gissa lite annan vinkel
[t,x0] = trajectory_calculation(0.02,150,f,[0;h0;cos(a0)*v0;sin(a0)*v0]);
[t,x1] = trajectory_calculation(0.02,150,f,[0;h0;cos(a1)*v0;sin(a1)*v0]);
ai = a0;
aip = a1;
xi = x1;
xip = x0;
for i = 1:10
    ainew = ai - (xi-20) * (ai - aip) / (xi - xip);
    [t,xinew] = trajectory_calculation(0.02,150,f,[0;h0;cos(ainew)*v0;sin(ainew)*v0]);
    aip = ai;
    xip = xi;
    ai = ainew;
    xi = xinew;
    % avsluta om nått toleransnivå bestämd innan
    if abs(xinew-20) < tolerance
        break
    end
end

% spara roten och banan
root_a_2 = ai; 
x_2 = xi;
traj_2 = t;

% plotta
figure(1);
title(1,'Trajectory over time')
hold on;
plot(traj_1(2,1:end),traj_1(3,1:end));
plot(traj_2(2,1:end),traj_2(3,1:end));
plot([0,20],[0,0]);
legend('trajectory 1','trajectory 2')

%% c)
clc;

% funktion för beräkna felet med störningar till a och v0:
function err = traj_error(a,a_err,v0_err,f,h0,v0)
    [tj,xval] = trajectory_calculation(0.02,150,f,[0;h0;cos(a*a_err)*v0*v0_err;sin(a*a_err)*v0*v0_err]);
    err = abs(20-xval);
end

% för höga kastet:
high_a_max_err = max([traj_error(root_a_2,1.05,1,f,h0,v0)...
                      traj_error(root_a_2,0.95,1,f,h0,v0)]);
high_v0_max_err = max([traj_error(root_a_2,1,1.05,f,h0,v0)...
                       traj_error(root_a_2,1,0.95,f,h0,v0)]);
max_err_high = max([high_a_max_err + high_v0_max_err,traj_error(root_a_2,1.05,1.05,f,h0,v0),traj_error(root_a_2,0.95,0.95,f,h0,v0)])

% för låga kastet:
low_a_max_err = max([traj_error(root_a_1,1.05,1,f,h0,v0)...
                      traj_error(root_a_1,0.95,1,f,h0,v0)]);
low_v0_max_err = max([traj_error(root_a_1,1,1.05,f,h0,v0)...
                       traj_error(root_a_1,1,0.95,f,h0,v0)]);
max_err_low = max([low_a_max_err + low_v0_max_err,traj_error(root_a_1,1.05,1.05,f,h0,v0),traj_error(root_a_1,0.95,0.95,f,h0,v0)])

% det låga har lägre fel!




