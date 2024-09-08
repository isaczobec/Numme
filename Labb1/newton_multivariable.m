function r = newton_multivariable(F,DF,x0,iters,step_length,plot_fe,stop_error,print_iterations)
arguments
    F;
    DF;
    x0;
    iters;
    step_length = 1;
    plot_fe=false;
    stop_error=0;
    print_iterations=false;
end
% approximates a root vector r given an n-component vector-valued function
% F, its jacobian DF, and an initial guess x0 (n-component vector) using iters iterations.
% DF (E Rn*Rn) and F (E Rn) should be functions taking a vector with n components.
%   Detailed explanation goes here


xi = x0;

% transponera x0 om det behövs
if length(F(x0)) == width(x0)
    x0 = x0';
end

fe = zeros(1,iters);


% använd formeln för newtons metod i flera variabler iters gånger
% lös ut s istället för att beräkna inversen av DF
for i = 1:iters
    xprev = xi;
    %s = solve_linear_equation_matrix(DF(xi),F(xi)) * -1; % egen, nog sämre
    s = -linsolve(DF(xi),F(xi)); % om man vill använda inbyggd ekvationslösnin
    xi = xi + s*step_length;
    fe(1,i) = norm(F(xi));
    if max(abs(xprev - xi)) < stop_error % antar att felet alltid minskar
        if print_iterations
            i % print iterations taken
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

end