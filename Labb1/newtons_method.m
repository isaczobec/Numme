function root = newtons_method(f,x0,num_iters,dfdx, stop_error_difference)
arguments
    f
    x0
    num_iters
    dfdx = @(x) (f(x + 0.001) - f(x))/0.001
    stop_error_difference = 0
end
% NEWTONS_METHOD approximates a root for f(x) using newtons method.

% säkerställ att stop error difference är positiv
stop_error_difference = abs(stop_error_difference);

xi = x0;
for i = 1:num_iters
    xi1 = xi - (f(xi))./(dfdx(xi));
    if abs(max(xi1-xi)) < stop_error_difference
        disp(['Nådde specefierad skillnad i svar efter ',num2str(i),' iterationer.'])
        xi = xi1;
        break
    end
    xi = xi1;
end

root = xi;

end