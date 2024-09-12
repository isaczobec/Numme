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
% USDSEK = flipud(USDSEK);

plot(1:n,USDSEK')


% definiera funktionerna
syms t d0 d1 d2 d3 L
f(t,d0,d1,d2,d3,L) = d0 + d1*t + d2 * sin(2*pi*t/L) + d3 * cos(2*pi*t/L);
% partiella förstaderivator
dfdd0(t,d0,d1,d2,d3,L) = 1 + 0*t;
dfdd1(t,d0,d1,d2,d3,L) = t;
dfdd2(t,d0,d1,d2,d3,L) = sin(2*pi*t/L);
dfdd3(t,d0,d1,d2,d3,L) = cos(2*pi*t/L);
dfdL(t,d0,d1,d2,d3,L) = d2*(cos(2*pi*t/L))*-2*pi*t*(L^(-2)) + d3*-1*(sin(2*pi*t/L))*-2*pi*t*(L^(-2));

ds = {dfdd0,dfdd1,dfdd2,dfdd3,dfdL};
am_vars = length(ds);

% kod utkommenterad eftersom tar lång tid, laddar in funktioner senare
%{
% definiera r, stoppa in alla datapunkter
r = sym('r',[n,1]);
for i = 1:n
    r(i) = subs(f(t,d0,d1,d2,d3,L),t,i) - USDSEK(i);
end

Dr = sym('Dr',[n,am_vars]);
for i = 1:n
    for j = 1:am_vars
        Dr(i,j) = subs(ds{j},t,i);
    end
end

% definiera gradient av error-squared funktionen
E_grad = (r'*Dr)';


% beräkna automatiskt ut Jacobianen
DE_grad = sym('DED',[am_vars,am_vars]);
for i = 1:am_vars
    DE_grad(i,1:am_vars) = gradient(E_grad(i))';
end

% skapa matlabfunktioner som kan evalueras
F = matlabFunction(E_grad);
DF = matlabFunction(DE_grad);

% spara funktioner
save('upg4_funcs.mat',"r","Dr","E_grad","DE_grad");
save('upg4_anon_funcs.mat',"F","DF");

%}
%load upg4_anon_funcs.mat; % ladda in funktioner

% definiera funktionen och dess jacobian som att ta en vektor som input
vF = @(x) F(x(1),x(2),x(3),x(4),x(5));
vDF = @(x) DF(x(1),x(2),x(3),x(4),x(5));

iters = 15;
x0 = [7.9678,-0.0017,0.2802,0.3840,500]' % börja med approximationer från förra uppgiften
roots = newton_multivariable(vF,vDF,x0,iters,0.4,true,0,false,true)

% plotta fel 
figure(4);
plot(1:n,USDSEK);hold on;

anp_f_3 = @(t,cs) cs(1) + cs(2)*t + cs(3) * sin(2*pi*t/cs(5)) + cs(4) * cos(2*pi*t/cs(5))
for i = 1:iters
    anp = @(t) anp_f_3(t,roots(1:length(x0),i));
    ys = anp(1:n);
    mse = sum((USDSEK' - ys).^2)/n
    plot(1:n,ys);hold on;
end

vF(roots(1:5,15))