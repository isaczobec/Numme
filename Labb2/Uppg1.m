%% a)

clearvars;close all;clc

% funktionen f för konturen
g = @(r) (3*r.^3 .* exp(-r))./(1+1/3*sin(8*r/5));
f = @(r) g(r) .* r;

% deklarera parametrar
R = 3;
ns = [30,60];
V0 = g(R)*R^2*pi; 

% beräkna volymerna
V2h_trap = V0 - 2*pi*trapezoid_rule(f,ns(1),0,R)
Vh_trap = V0 - 2*pi*trapezoid_rule(f,ns(2),0,R)
V2h_simp = V0 - 2*pi*simpsons_rule(f,ns(1),0,R)
Vh_simp = V0 - 2*pi*simpsons_rule(f,ns(2),0,R)

% felet baserat på |Vh - V| <= |V2h - V|
err_diff_trap = abs(V2h_trap-Vh_trap)
err_diff_simp = abs(V2h_simp-Vh_simp)

% beräkna vilket n som behövs för trapetsmetoden respektive simpsons regel
des_err = 0.5 * 10^-4;
n_trap = 1;
err_diff_trap_test = 99999999999999;
while err_diff_trap_test > des_err
    err_diff_trap_test = 2*pi*abs(trapezoid_rule(f,n_trap,0,R)-trapezoid_rule(f,n_trap*2,0,R));
    n_trap = n_trap*2;
end
disp(['trapezoid: took n = ',num2str(n_trap),' to reach error ',num2str(des_err)])
n_simp = 1;
err_diff_simp_test = 99999999999999;
while err_diff_simp_test > des_err
    err_diff_simp_test = 2*pi*abs(simpsons_rule(f,n_simp,0,R)-simpsons_rule(f,n_simp*2,0,R));
    n_simp = n_simp*2;
end
disp(['simpson: took n = ',num2str(n_simp),' to reach error ',num2str(des_err)])


%% b)

clc;

% ange funktionen och parametrarna
L = 3*sqrt(2);
f2d = @(x,y) g(R)-g(sqrt(x.^2+y.^2));

% beräkna volymen
Vol = trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,30,30)

% felet måste vara mindre än 0.5*10^-3 för tre korrekta decimaler

% beräkna vilket n som behövs
des_err = 0.5 * 10^-3;
n_trap2d = 30;
err_diff_simp = 999999; % välj godtyckligt stort tal till att börja med
while err_diff_simp > des_err
    err_diff_simp = abs( ...
        trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,n_trap2d,n_trap2d) ...
        -trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,n_trap2d*2,n_trap2d*2));
    n_trap2d = n_trap2d*2;
end
disp(['took h = ',num2str(L/n_trap2d),' to reach error ',num2str(des_err)])
Vol_exact = trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,n_trap2d,n_trap2d)

%% c) I

close all;clc;

% beräkna godtyckligt exakta volymer
large_n = 2999;
V1D = simpsons_rule(f,large_n,0,R)
V2D = trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,large_n,large_n)


% fyll en vektor med fel
ns = 30:15:1500;
len_ns = length(ns);
errs_vec = zeros(3,len_ns);
for i = 1:len_ns
    errs_vec(1,i) = abs(trapezoid_rule(f,ns(i),0,R)-V1D);
    errs_vec(2,i) = abs(simpsons_rule(f,ns(i),0,R)-V1D);
    errs_vec(3,i) = abs(trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,ns(i),ns(i))-V2D);
end

% beräkna h-värden
hs1d_trap = R./ns;
hs1d_simp = hs1d_trap/2; % hälften så stort h i simp
hs2d = L./ns;

figure(1);
title(1,'Fel beroende av h')
hold on;
grid on;
loglog(hs1d_trap,errs_vec(1,1:end)) % verkar ha noggranhetsordning 2
loglog(hs1d_simp,errs_vec(2,1:end)) % verkar ha noggranhetsordning 4
loglog(hs2d,errs_vec(3,1:end)) % verkar ha noggranhetsordning 2
legend('trapezoidregeln','simpsons regel','trapezoidregeln-2D')

%% c) II

clc;

% fyll en vektor med fel

hs = 2.^(0:6) * 10^-3; % dubbla steglängd varje gång

% fyll vektor med volymer för dubbblande steglängder varje gång
ns1d = round(R./hs);
ns2d = round(L./hs);
len_ns = length(hs);
vols_vec = zeros(3,len_ns);
for i = 1:len_ns
    vols_vec(1,i) = trapezoid_rule(f,ns1d(i),0,R);
    vols_vec(2,i) = simpsons_rule(f,ns1d(i),0,R);
    vols_vec(3,i) = trapezoid_rule_2d(f2d,-L/2,L/2,-L/2,L/2,ns2d(i),ns2d(i));
end
    
offset_vols1 = vols_vec(1:end,3:end);
offset_vols2 = vols_vec(1:end,2:end-1);
offset_vols3 = vols_vec(1:end,1:end-2);

ratios = (offset_vols1-offset_vols2)./(offset_vols2-offset_vols3);
approx_noggranhets = log2(ratios); 
% ger trapetsregeln i 1d/2d noggranhetsordning 2, simpsons 4