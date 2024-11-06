function vals = eulers_method(dydt,y0,t0,h,steps)
arguments
    dydt
    y0 = 0
    t0 = 0
    h = 0.1
    steps = 100
end
%UNTITLED4 Summary of this function goes here
%   dydt should be a function f(t,y) = dy/dt. Returns a matrix where the
%   first row is t values, the second y values.

func_points = zeros(2,steps); % preallocate arrays

yn = y0;
tn = t0;

for i = 1:steps

    % add current t and y to vector
    func_points(1:2,i) = [tn;yn];

    slope = dydt(tn,yn);
    yn = yn + slope * h;
    tn = tn + h;
end

vals = func_points;

end