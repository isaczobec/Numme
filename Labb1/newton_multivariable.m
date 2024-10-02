function r = newton_multivariable(F,DF,x0,iters,step_length,plot_fe,stop_error_difference,print_iterations,return_list)
arguments
    F;
    DF;
    x0;
    iters;
    step_length = 1;
    plot_fe=false;
    stop_error_difference=0;
    print_iterations=false;
    return_list = false;
end
% approximates a root vector r given an n-component vector-valued function
% F, its jacobian DF, and an initial guess x0 (n-component vector) using iters iterations.
% DF (E Rn*Rn) and F (E Rn) should be functions taking a vector with n components.
%   Detailed explanation goes here

n = length(F(x0));
xi = x0;

% transponera x0 om det behövs
if length(F(x0)) == width(x0)
    x0 = x0';
end

fe = zeros(1,iters);

rs = zeros(n,iters);

% använd formeln för newtons metod i flera variabler iters gånger
% lös ut s istället för att beräkna inversen av DF
for i = 1:iters
    rs(1:n,i) = xi;
    xprev = xi;
    %s = solve_linear_equation_matrix(DF(xi),F(xi)) * -1; % egen, nog sämre
    s = -linsolve(DF(xi),F(xi)); % om man vill använda inbyggd ekvationslösnin
    xi = xi + s*step_length;
    fe(1,i) = norm(F(xi));
    if max(abs(xprev - xi)) < stop_error_difference % antar att felet alltid minskar
        if print_iterations
            disp(['iterations taken to reach desired error: ',string(i)]) % print iterations taken
        end
        r = xi;
        return
    end
end

if (plot_fe)
    figure(37);
    plot(1:iters,fe);
end

r = xi;
if (return_list)
    r = rs;
end
end