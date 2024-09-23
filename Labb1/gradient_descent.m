function root = gradient_descent(x0, nabla_F, step_len, iterations)
arguments
    x0
    nabla_F
    step_len = 0.1
    iterations = 100
end
% returns a root found using gradient descent. x0 is an n-dimensional vector, the start guess
% vector, nabla_F is the gradient of a function (an n-dimensional vector taking n inputs). 

xi = x0; 
for i = 1:iterations
    xi = xi - step_len * nabla_F(xi); 
end
root = xi;  

end
