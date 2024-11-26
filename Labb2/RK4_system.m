function vals = RK4_system(dydt,y0,t0,h,steps)
arguments
    dydt
    y0 = [0,0]
    t0 = 0
    h = 0.1
    steps = 100
end
%   dydt should be a vector valued function f(t,[y1;...yn]) = [dy1/dt;...dyn/dt]. y0 should be
%   a column vector containing n start ys.
%   Returns a matrix where the
%   first row is t values, the following y1 through yn values.

n = length(y0); % assume length of initial values vector is the size of the system
func_points = zeros(n+1,steps+1); % preallocate arrays, one for time
func_points(1:end,1) = [t0;y0];

yi = y0;
ti = t0;

k = zeros(n,4);

for i = 1:steps

    % calculate slopes and average them
    k(1:end,1) = dydt(ti,yi);
    k(1:end,2) = dydt(ti + h/2,yi + h/2*k(1:end,1));
    k(1:end,3) = dydt(ti + h/2,yi + h/2*k(1:end,2));
    k(1:end,4) = dydt(ti + h, yi + h*k(1:end,3));

    slope = (k(1:end,1) + k(1:end,2) * 2 + k(1:end,3) * 2  + k(1:end,4))/6;

    % increment yn and tn
    yi = yi + slope * h;
    ti = ti + h;

    % add current t and y to vector
    func_points(1:end,i+1) = [ti;yi];
end

vals = func_points;

end