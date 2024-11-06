function vals = RK4(dydt,y0,t0,h,steps)
arguments
    dydt
    y0 = 0
    t0 = 0
    h = 0.1
    steps = 100
end
%UNTITLED Summary of this function goes here
%   dydt should be a function f(t,y) = dy/dt. Returns a matrix where the
%   first row is t values, the second y values.

func_points = zeros(2,steps); % preallocate arrays

yn = y0;
tn = t0;
weight_matrix = [1,2,2,1];
weight = sum(weight_matrix);
k = zeros(4,1);

for i = 1:steps

    % add current t and y to vector
    func_points(1:2,i) = [tn;yn];

    % calculate slopes and average them
    k(1) = dydt(tn,yn);
    k(2) = dydt(tn + h/2,yn + h/2*k(1));
    k(3) = dydt(tn + h/2,yn + h/2*k(2));
    k(4) = dydt(tn + h, yn + h*k(3));

    slope = (weight_matrix*k)/weight;

    % increment yn and tn
    yn = yn + slope * h;
    tn = tn + h;
end

vals = func_points;

end