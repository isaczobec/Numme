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

%{
a = very_wrong(1:2);
b = very_wrong(3:4);
c = very_wrong(5:6);
ra = very_wrong(7);
rb = very_wrong(8);
rc = very_wrong(9);
%}

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
xcb = [1.3,-3.09,4,-0.15]';
xab = [-0.9,2.5,3.5,1.6]';
xac = [-1.9,1.9,-1.7,-2.2]';
xcb = xcb + 0.5;


% definiera unika F och DF för varje fall
Fcb = @(x) F(x,rc,rb,c,b);
DFcb = @(x) DF(x,c,b);
Fab = @(x) F(x,ra,rb,a,b);
DFab = @(x) DF(x,a,b);
Fac = @(x) F(x,ra,rc,a,c);
DFac = @(x) DF(x,a,c);

% beräkna rötterna
% FIXA: newtons metod konvergerade inte mot denna rot, använde en annan
% istället
startc = goofy_method(Fcb,xcb,0.6,0.8,100);
rcb = newton_multivariable(Fcb,DFcb,startc,300,0.5,true,10e-11,true) % denna gör inget rn
rab = newton_multivariable(Fab,DFab,xab,300,0.2,false,10e-11,true)
rac = newton_multivariable(Fac,DFac,xac,300,0.2,false,10e-11,true)


figure(4);
% plotta linjerna

plot(rcb([1,3]),rcb([2,4])); hold on;
%point1 = x_circ_c(rcb(1))'
%point2 = x_circ_b(rcb(2))'
%plot([point1(1),point2(1)],[point1(2),point2(2)]); hold on;
plot(rab([1,3]),rab([2,4])); hold on;
plot(rac([1,3]),rac([2,4])); hold on;

% plotta startvärden
plot(xcb([1,3]),xcb([2,4]),'.'); hold on;
plot(xab([1,3]),xab([2,4]),'.'); hold on;
plot(xac([1,3]),xac([2,4]),'.'); hold on;

% beräkna snörets längd
% funktion för beräkna vinkeln, uttnyttjar |a*b| = abcos(theta)
ang = @(midpoint,a,b) acos(((a-midpoint)'*(b-midpoint))/(norm(a-midpoint)*norm(b-midpoint)));

arc_a = ang(a,rac(1:2),rab(1:2)) * ra;
arc_b = ang(b,rcb(3:4),rab(3:4)) * rb;
arc_c = ang(c,rcb(1:2),rac(3:4)) * rc;

snorelangd = norm(rac) + norm(rab) + norm(rcb) + arc_a + arc_b + arc_c


%% d)
close all;clc;

% beräkna hur många olika kombinationer av att lägga till backward error
% det finns (addera, subtrahera eller ingenting)

def_len = snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF);
def_input = [a;b;c;ra;rb;rc]; % skriv om inputen i en vektor

num_states = 3^9 - 1; % 9 inputvariabler, inget fall där man har 0 överallt

be = 0.1; % ange backward error
load fe_vec_snorlangd.mat; % ladda felvektor
start_index = find(fe_vec == 0,1,"first")
start_index = 17698

% beräkan ungefärlig exekveringstid
tic;
snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF);
ex_time = toc*(num_states-start_index)


% beräkna alla möjliga errors
for i = start_index:num_states
    fi = def_input + (num2base_list(i,3,9)-1)'*be;
    fe_vec(i) = abs(def_len - snorlangd(fi(1:2),fi(3:4),fi(5:6),fi(7),fi(8),fi(9),xab,xac,xcb,F,DF));
end

save fe_vec_snorlangd.mat fe_vec; % spara vektorn

% hitta maxvärdet
[max_error,I] = max(fe_vec)

