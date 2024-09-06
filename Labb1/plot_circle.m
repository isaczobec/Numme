function a = plot_circle(x,y,radius,points,style)
arguments
    x 
    y 
    radius 
    points 
    style = '';
end
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

angles = linspace(0,2*pi,points);

xs = cos(angles) * radius + x;
ys = sin(angles) * radius + y;

plot(xs,ys,style);

end