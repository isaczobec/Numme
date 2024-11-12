function root = bisection_method(f,a,b,max_error,max_iterations)
% approximates a solution to f(x) = 0 on [a,b] using the bisection method
% returns the closest guess EVEN if no root was found.


current_exponent = 1;

% current boundaries
ca = a;
cb = b;

for i = 1:max_iterations

    xs = linspace(ca,cb, 2^(current_exponent)+1);
    xs1 = xs(1:end-1);
    xs2 = xs(2:end);
    diffs = zeros(1,length(xs1));
    for s = 1:length(xs1)
        diffs(s) = f(xs1(s)) * f(xs2(s));
    end
    
    for j = 1:length(diffs)
        % if signs are opposite, we know there is a root
        if diffs(j) <= 0 
            current_exponent = 0;
            ca = xs(j);
            cb = xs(j+1);

            if abs(ca-cb) <= max_error % we found an acceptable root
                root = (ca+cb)/2;
                return
            end
            break
        end
    end

    current_exponent = current_exponent+1;

end

root = (ca + cb)/2;
return

end
