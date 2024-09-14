function o = plot_phase_portrait(dxdt,dydt,step,iterations,xrange,yrange,pointsxy)
% plots the trajectory of solution curves to a differential equation, given
% the derivatives of x and y with respect to t (dxdt & dydt should take two inputs, 
% a vector of x-values and a vector of y values respectively)
% [x,y] as input. xrange and yrange are on the form [a,b] and determine in
% which area the points should be distributed. pointsxy are on the form
% [m,n] e N and determine how many starting points there should be.
% iterations are how many times the equation will iterate.

% calculate the amount of starting points
amount_points = pointsxy(1) * pointsxy(2);

x_points_step = (xrange(2) - xrange(1))/(pointsxy(1)-1);
y_points_step = (yrange(2) - yrange(1))/(pointsxy(2)-1);

% pre-allocate matricies with x and y values and set their initial values
x_vals = zeros(amount_points,iterations+1);
y_vals = zeros(amount_points,iterations+1);
for i = 1:pointsxy(1)
    for j = 1:pointsxy(2)
        x_vals((i-1)*pointsxy(2)+j) = xrange(1) + (i-1) * x_points_step;
        y_vals((i-1)*pointsxy(2)+j) = yrange(1) + (j-1) * y_points_step;
    end
end

% iterate the equations
for i = 2:iterations+1
    x_vals(1:end,i) = x_vals(1:end,i-1) + step * dxdt(x_vals(1:end,i-1),y_vals(1:end,i-1));
    y_vals(1:end,i) = y_vals(1:end,i-1) + step * dydt(x_vals(1:end,i-1),y_vals(1:end,i-1));
end

% plot all solution curves
grid on;
for i = 1:amount_points
    plot([x_vals(i,1)],[y_vals(i,1)],'o')
    plot(x_vals(i,1:end),y_vals(i,1:end),'b');
    hold on;
end