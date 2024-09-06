%% a) & b)
clearvars,clc,close all;

% definiera parametrar
a = [-1.5,3]';
b = [1,1]';
ra = 1.5;
rb = 0.8;

% definiera F och dess jacobian
% x(1),x(2) är x1, y1, x(3),x(4) är x2, y2
F = @(x) [(x(1)-a(1))^2+(x(2)-a(2))^2-(ra^2);...
          (x(3)-b(1))^2+(x(4)-b(2))^2-(rb^2);...
          (x(1)-x(3))*(x(1)-a(1)) + (x(2)-x(4))*(x(2)-a(2));...
          (x(1)-x(3))*(x(3)-b(1)) + (x(2)-x(4))*(x(4)-b(2))...
    ];
DF = @(x) [2*(x(1)-a(1)), 2*(x(2)-a(2)), 0, 0;...
           0, 0, 2*(x(3)-b(1)), 2*(x(4)-b(2));...
           2*x(1)-x(3)-a(1),2*x(2)-x(4)-a(2),a(1)-x(1),a(2)-x(2);...
           x(3)-b(1),x(4)-b(2),-2*x(3)+b(1)+x(1),-2*x(4)+b(2)+x(3)...
    ];


% sätt startgissning och lös m newtons metod
x01 = [-1,4,1.5,1.5]';
x02 = [-2.4,2,0.5,0.3]';
% i = antal iterationer som krävdes
ans1 = newton_multivariable(F,DF,x01,300,0.6,false,10e-11)
ans2 = newton_multivariable(F,DF,x02,300,1,false,10e-11)

%% b) plotta figuren

figure(3)
plot_circle(a(1),a(2),ra,100);hold on;
plot_circle(b(1),b(2),rb,100);hold on;
plot([ans1(1),ans1(3)],[ans1(2),ans1(4)]);hold on;
plot([x01(1),x01(3)],[x01(2),x01(4)],'.');hold on;
plot([ans2(1),ans2(3)],[ans2(2),ans2(4)]);hold on;
plot([x02(1),x02(3)],[x02(2),x02(4)],'.');hold on;


%% c)

clc; close all;

% definiera parametrar
a = [-1,1.5]';
b = [3,0.5]';
c = [0,-2]';
ra = 1;
rb = 1.2;
rc = 1.7;

% definiera anonym funk för F och DF där x E R4; r1,r2 är cirklar 1&2:s
% radie, p1,p2 deras mittpunkter
F = @(x,r1,r2,p1,p2)... 
         [(x(1)-p1(1))^2+(x(2)-p1(2))^2-(r1^2);...
          (x(3)-p2(1))^2+(x(4)-p2(2))^2-(r2^2);...
          (x(1)-x(3))*(x(1)-p1(1)) + (x(2)-x(4))*(x(2)-p1(2));...
          (x(1)-x(3))*(x(3)-p2(1)) + (x(2)-x(4))*(x(4)-p2(2))...
    ];
DF = @(x,p1,p2)... 
          [2*(x(1)-p1(1)), 2*(x(2)-p1(2)), 0, 0;...
           0, 0, 2*(x(3)-p2(1)), 2*(x(4)-p2(2));...
           2*x(1)-x(3)-p1(1),2*x(2)-x(4)-p1(2),a(1)-x(1),p1(2)-x(2);...
           x(3)-p2(1),x(4)-p2(2),-2*x(3)+p2(1)+x(1),-2*x(4)+p2(2)+x(3)...
    ];

% plotta cirklar utan trådar
figure(4)
plot_circle(a(1),a(2),ra,100,'r'); hold on;
plot_circle(b(1),b(2),rb,100,'g'); hold on;
plot_circle(c(1),c(2),rc,100,'b'); hold on;

% läs av approximativa lösningar från bilden
xcb = [1.23035,-3.17313,4.11404,0.054]';
xab = [-0.9,2.5,3.5,1.6]';
xac = [-1.9,1.9,-1.7,-2.2]';

% definiera unika F och DF för varje fall
Fcb = @(x) F(x,rc,rb,c,b);
DFcb = @(x) DF(x,c,b);
Fab = @(x) F(x,ra,rb,a,b);
DFab = @(x) DF(x,a,b);
Fac = @(x) F(x,ra,rc,a,c);
DFac = @(x) DF(x,a,c);

% beräkna rötterna
rcb = newton_multivariable(Fcb,DFcb,xcb,100,1,true,10e-11)
rab = newton_multivariable(Fab,DFab,xab,300,0.2,false,10e-11)
rac = newton_multivariable(Fac,DFac,xac,300,0.2,false,10e-11)

% plotta linjerna
figure(4)
plot(rcb([1,3]),rcb([2,4])); hold on;
plot(rab([1,3]),rab([2,4])); hold on;
plot(rac([1,3]),rac([2,4])); hold on;
% plotta startvärden
plot(xcb([1,3]),xcb([2,4]),'.'); hold on;
plot(xab([1,3]),xab([2,4]),'.'); hold on;
plot(xac([1,3]),xac([2,4]),'.'); hold on;