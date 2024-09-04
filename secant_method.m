function root = secant_method(f,x0,x1,num_iters)

for i = 1:num_iters
    if x0 == x1
        root = x1;
        return
    end
    currentSlope = (f(x0) - f(x1))/(x0-x1); % calculate slope
    newX = x1 - f(x1)/currentSlope; % plug into newtons method formula
    % update values
    x0 = x1;
    x1 = newX;
end

root = x1;