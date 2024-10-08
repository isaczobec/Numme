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
DF = @(x) [2*(x(1)-a(1)), 2*(x(2)-a(2)), 0, 0; ...
           0, 0, 2*(x(3)-b(1)), 2*(x(4)-b(2)); ...
           2*x(1) - x(3) - a(1), 2*x(2) - x(4) - a(2), -(x(1)-a(1)), -(x(2)-a(2)); ...
           -(x(3)-b(1)), -(x(4)-b(2)), x(1) - 2*x(3) + b(1), x(2) - 2*x(4) + b(2)];


% sätt startgissning och lös m newtons metod
x01 = [-1,4,1.5,1.5]';
x02 = [-2.4,2,0.5,0.3]';
x03 = [-0.1,2.8,0.2,1.03]';
x04 = [-1.3,1.5,0.9,1.8]';
step_lens = [0.6,0.6,0.2,0.6];
start_guesses = [x01,x02,x03,x04]; % matris med startgissningar
% i = antal iterationer som krävdes
root_mat = zeros(height(start_guesses),width(start_guesses));
for i = 1:width(start_guesses)
    root_mat(1:end,i) = newton_multivariable(F,DF,start_guesses(1:end,i),500,step_lens(i),false,10e-11);
end
root_mat % skriv ut rötter

%% b) plotta figuren

figure(3)
hold on;
title('Snöre och cirkel')
% plotta cirklar
plot_circle(a(1),a(2),ra,100);
plot_circle(b(1),b(2),rb,100);
% plotta snören
for i = 1:width(root_mat)
    plot([root_mat(1,i),root_mat(3,i)],[root_mat(2,i),root_mat(4,i)])
end
% plotta startgissningar
for i = 1:width(root_mat)
    plot([start_guesses(1,i),start_guesses(3,i)],[start_guesses(2,i),start_guesses(4,i)],'o')
end


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
xcb = [1.3,-3.09,4,-0.15]';
xab = [-0.9,2.5,3.5,1.6]';
xac = [-1.9,1.9,-1.7,-2.2]';
xcb = xcb + 0.5;


% definiera unika F och DF för varje fall
Fcb = @(x) F(x,rb,rc,b,c);
DFcb = @(x) DF(x,b,c);
Fab = @(x) F(x,ra,rb,a,b);
DFab = @(x) DF(x,a,b);
Fac = @(x) F(x,ra,rc,a,c);
DFac = @(x) DF(x,a,c);

% beräkna rötterna
rbc = newton_multivariable(Fcb,DFcb,xcb,300,0.5,true,10e-11,true) 
rab = newton_multivariable(Fab,DFab,xab,300,0.2,false,10e-11,true)
rac = newton_multivariable(Fac,DFac,xac,300,0.2,false,10e-11,true)


figure(4);
% plotta linjerna


plot(rbc([1,3]),rbc([2,4])); hold on;
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
arc_b = ang(b,rbc(1:2),rab(3:4)) * rb;
arc_c = ang(c,rbc(3:4),rac(3:4)) * rc;

snorelangd = norm(rac(1:2)-rac(3:4)) + norm(rab(1:2)-rab(3:4)) + norm(rbc(1:2)-rbc(3:4)) + arc_a + arc_b + arc_c


%% d)
close all;clc;

% beräkna hur många olika kombinationer av att lägga till backward error
% det finns (addera, subtrahera eller ingenting)

def_len = snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF)
def_input = [a;b;c;ra;rb;rc]; % skriv om inputen i en vektor

% ta varje variabel kan va 0 eller +0.01
num_states = 3^9 - 1; % 9 inputvariabler, inget fall där man har 0 överallt

be = 0.01; % ange backward error

load new_err_vec.mat

start_index = 16370;

% beräkan ungefärlig exekveringstid
tic;
test_tries = 20;
for i = 1:test_tries
snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF);
end
ex_time = toc*(num_states-start_index)/test_tries/60

% fe_vec = zeros(1,num_states);


% beräkna alla möjliga errors
for i = start_index:num_states
    fi = def_input + (num2base_list(i,3,9)-1)'*be; % num2base-listan kan vara 0, 1 eller 2
    fe_vec(i) = abs(def_len - snorlangd(fi(1:2),fi(3:4),fi(5:6),fi(7),fi(8),fi(9),xab,xac,xcb,F,DF));
end


save new_err_vec.mat fe_vec

% hitta maxvärdet
[max_error,I] = max(fe_vec)

% för alla 3^9-1 möjliga fall : max_error 0.1306 index 6344

% när bara positiva bakcwarderrors: ca 0.09
% när bara positiva backwaarderrors: ca 0.13

%% d) test case

max_index = 6344; % det indexet som gav max av alla möjliga fall
be = 0.01; % ange backward error

def_len = snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF)
def_input = [a;b;c;ra;rb;rc]; % skriv om inputen i en vektor

bast_storning = (num2base_list(max_index,3,9)-1)

fi = def_input + bast_storning'*be; 
error_maxad_sigma_rizz = abs(def_len - snorlangd(fi(1:2),fi(3:4),fi(5:6),fi(7),fi(8),fi(9),xab,xac,xcb,F,DF))


%% d) mer realistisk

clc

def_len = snorlangd(a,b,c,ra,rb,rc,xab,xac,xcb,F,DF)
def_input = [a;b;c;ra;rb;rc]; % skriv om inputen i en vektor

be = 0.01; % ange backward error

n_dist = 100;
n_inp = length(def_input);

% räkna ut matris med störningar
dist_mat = (randi(3,n_inp,n_dist)-2)*be;

fe_vec_new = zeros(1,n_dist);

% beräkna några olika fel utifrån disturbance-matrisen
for i = 1:n_dist
    fi = def_input + dist_mat(1:end,i);
    fe_vec_new(i) = abs(def_len - snorlangd(fi(1:2),fi(3:4),fi(5:6),fi(7),fi(8),fi(9),xab,xac,xcb,F,DF));
end

% hitta största felet
m_err = max(fe_vec_new)