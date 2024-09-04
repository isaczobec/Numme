clearvars,clc,close all

A = [2 2 4; 4 1 6; 6 12 9;];
b = [6 9 3]';

[L,U] = LU_factor(A);
1+1
% params
maxN = 80;
maxVal = 3;
ns = 1:maxN;
times = zeros(1,maxN);
reps = 50;

for n = ns % every matrix size loop
    for r = 1:reps
        A = randi(maxVal,n);
        okDets = 0;
        while okDets == 0
            for i = 1:n % check if all sub matricies are ok
                if det(A(1:i,1:i)) == 0
                    A = randi(maxVal,n); % generate new and break
                    break % not reached if dets are ok
                else 
                    if i == n
                        % it was ok
                        okDets = 1;
                    end
                end
            end
        end
        % we have a viable matrix
        b = randi(maxVal,n);
        tic;
        solve_linear_equation_matrix(A,b);
        time = toc;
        times(1,n) = times(1,n) + time;
    end
end

times = times / reps; % average time

plot(ns,times);




