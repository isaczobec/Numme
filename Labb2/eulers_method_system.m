function vals = eulers_method_system(dydt,y0,t0,h,steps)
arguments
    dydt
    y0 = [0]
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

yn = y0;
tn = t0;

for i = 1:steps

    slope = dydt(tn,yn);
    yn = yn + slope * h;
    tn = tn + h;

    % add current t and y to vector
    func_points(1:end,i+1) = [tn;yn];
end

vals = func_points;

end