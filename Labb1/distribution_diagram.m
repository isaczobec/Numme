function r = distribution_diagram(list_vals,bounds,step,plot_options)
arguments
    list_vals = []
    bounds = [-10,10]
    step = 0.1
    plot_options = '*'
end

n = length(list_vals);


num_slots = floor(abs(bounds(2) - bounds(1)) / step);

distribution = zeros(1,num_slots);
for i = 1:num_slots
    distribution(i) = sum(list_vals >= bounds(1) + step*(i-1) & list_vals < bounds(1) + step*(i))/n;
end

dist = sum(distribution)

plot(((1:num_slots)-1)* step,distribution,plot_options);


end