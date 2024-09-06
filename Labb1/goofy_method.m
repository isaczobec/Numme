function r = goofy_method(F,x0,start_step,step_multiplier,num_iters)

n = length(x0);
xi = x0;
amount_sample_points = 3^n;
step = start_step;


for j = 1:num_iters
    %step = norm(F(xi)) * step_multiplier;
    step = step * step_multiplier;
    
    % create guess and value array
    guesses = xi * ones(1,amount_sample_points);
    norms = ones(1,amount_sample_points);
    
    % create sample points and calculate their function value norm
    for i = 1:amount_sample_points
        guesses(1:end,i) = guesses(1:end,i) + (num2base_list(i-1,3,n)'-1)*step;
        norms(1,i) = norm(F(guesses(1:end,i)));
    end
    
    % find min value
    [M,I] = min(norms);
    
    xi = guesses(1:end,I);
end

r = xi;

end