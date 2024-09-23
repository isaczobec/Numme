%% a)
close all;clc;clearvars;

load 'dollarkurs.mat'
n = length(USDSEK);
% USDSEK = flipud(USDSEK);


% definiera funktion för matris med datapunkter
A = @(t) [ones(1,n);t]';

vals = A(1:length(USDSEK));

% gör mkm
HL_mat = vals'*vals;
VL_vek = vals'*USDSEK;
cs = HL_mat\VL_vek % lös ut koefficienterna

lin_f = @(t) cs(1) + t .* cs(2);


% plotta anpassningen och kursen
figure(1);
plot(1:n,USDSEK');hold on;
plot([1,n],[lin_f(1),lin_f(n)]);hold on;

err_vec = (lin_f(1:n) - USDSEK').^2
err = sum(err_vec)/n


%% b)

% plotta felet(i samma figur)
plot(1:n,err_vec)

% definiera matris
A2 = @(t,L) [ones(1,n);t;sin(2*pi*t/L);cos(2*pi*t/L)]';

L = 500; % observera att perioden verkar vara ca 500
vals2 = A2(1:n,L); % stoppa in x-värden i matrisen

% gör mkm
HL_mat = vals2'*vals2;
VL_vek = vals2'*USDSEK;
cs2 = HL_mat\VL_vek % lös ut koefficienter

% definiera funktion för anpassningen
f_anp_2 = @(t) cs2(1) + cs2(2)*t + cs2(3)*sin(2*pi*t/L) + cs2(4)*cos(2*pi*t/L);

% plotta och beräkna medelkvadratfel
xs = 1:n;
ys = f_anp_2(xs);
figure(2);
plot(xs,USDSEK');hold on;
plot(xs,ys);

m_error_squared = sum((ys - USDSEK').^2)/n

%% c)
close all;clc;

load 'dollarkurs.mat'
n = length(USDSEK);

% t och U är liggande vektorer med tid respektive dollarvärden
% g är funktionen som vi vill anpassa till, r är en stående vektor med alla
% ekvationer som ges av datapunkterna
g = @(t,U,d0,d1,d2,d3,L) d0 + d1*t + d2*sin(2*pi*t/L) + d3*cos(2*pi*t/L) - U;
r = @(d0,d1,d2,d3,L) g(1:n,USDSEK',d0,d1,d2,d3,L)';
% g_grad är gradienten av g m.a.p d0,..d3,L, där derivatorna extendas ut åt
% höger och varje ekvation neråt
g_grad = @(t,U,d0,d1,d2,d3,L) [ones(length(t),1),    t,  sin(2*pi*t/L),  cos(2*pi*t/L),...
    (1/L^2)*(-2*pi*d2*t).*cos(2*pi*t/L) + (1/L^2)*(2*pi*d3*t).*sin(2*pi*t/L)];
Dr = @(d0,d1,d2,d3,L) g_grad((1:n)',USDSEK,d0,d1,d2,d3,L);

% definiera F och DF enligt Gauss-Newtons metod
% gör så att de tar vektor som input för att kunna använda dem med newtons
% metod
F = @(x) (r(x(1),x(2),x(3),x(4),x(5))' * Dr(x(1),x(2),x(3),x(4),x(5)))'; % transponera F för att kunna lösa m Newtons metod
DF = @(x) Dr(x(1),x(2),x(3),x(4),x(5))' * Dr(x(1),x(2),x(3),x(4),x(5)); % droppa summationen

% startgissning för d0,d1,d2,d3,L
start_guess = [8,-0.0017,0.2802,0.384,600]';

root = newton_multivariable(F,DF,start_guess,100,1,true,0,false,false)
% root_grad_desc = gradient_descent(start_guess,F,0.001,100)

err_squared = @(root) sum(r(root(1),root(2),root(3),root(4),root(5)).^2);

err_gauss_newton = err_squared(root)
err_guess = err_squared(start_guess)


% plota funktionerna
% definiera handle för funktionen vi anpassar till
f = @(t,d0,d1,d2,d3,L) d0 + d1*t + d2*sin(2*pi*t/L) + d3*cos(2*pi*t/L);
figure(2);
hold on;
plot(1:n,USDSEK','b');
plot(1:n,f(1:n,start_guess(1),start_guess(2),start_guess(3),start_guess(4),start_guess(5)),'r');
plot(1:n,f(1:n,root(1),root(2),root(3),root(4),root(5)),'g');
