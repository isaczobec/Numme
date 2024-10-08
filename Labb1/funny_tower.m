clearvars, clc

load 'eiffel1.mat'
n = length(A)/2;
bel_node_index = 10;

bel__function = @(t) [1000*sin(0.2*t);1000*cos(0.2*t)];

animation_frames = 100;
delta_time = 1;


bel_mat = zeros(n*2,animation_frames);
bel_mat(bel_node_index:bel_node_index+1,1:end) = bel__function((0:animation_frames-1)*delta_time);

anim_mat = zeros(n*2,animation_frames);

[L,U] = lu(A);
Ls = sparse(L);
Us = sparse(U);

As = sparse(A);
disp_mat = As\bel_mat;

for i = 1:animation_frames
    x_disp = xnod + disp_mat(1:2:end-1,i);
    y_disp = ynod + disp_mat(2:2:end,i);
    trussplot(x_disp,y_disp,bars)
    pause(0.03);
end