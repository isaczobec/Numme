    function I = trapezoid_rule_2d(f,ax,bx,ay,by,m,n)
% m steps in x direction, n steps in y direction

hx = (bx - ax)/m;
hy = (by - ay)/n;

xs = linspace(ax,bx,m+1);
ys = linspace(ay,by,n+1);
[xs_mat,ys_mat] = meshgrid(xs,ys);
%xs_mat = ones(n+1,1)*(1:m+1)*hx + ax;
%ys_mat = (ones(m+1,1)*(1:n+1)*hy + ay)';

vals_mat = f(xs_mat,ys_mat);

center_mat = vals_mat(2:end-1,2:end-1); % included in 4 panels
edge_mat1 = vals_mat(1,2:end-1); % included in 2 panels
edge_mat2 = vals_mat(end,2:end-1);
edge_mat3 = vals_mat(2:end-1,1);
edge_mat4 = vals_mat(2:end-1,end);

center_sum = sum(sum(center_mat)') * 4;
edge_sum1 = sum(edge_mat1') * 2;
edge_sum2 = sum(edge_mat2') * 2;
edge_sum3 = sum(edge_mat3) * 2;
edge_sum4 = sum(edge_mat4) * 2;
corner_sum = vals_mat(1,1) + vals_mat(1,end) + vals_mat(end,1) + vals_mat(end,end);

tot_sum = center_sum + edge_sum4 + edge_sum3 + edge_sum2 + edge_sum1 + corner_sum;

I = tot_sum*hx*hy/4;

end