% a)

clearvars;close all;clc;

% paramterar
L = 4;
k = 2.2;
t0 = 290;
t1 = 400;

% ange Q(x)
Q = @(x) 3000*exp(-20*(x-0.6*L).^2) + 200;

% diskretisera [0,L] så att h(n+1) = L (n st puntker i intervallets interiör)
n = 19;
h = L/(n+1);

% skapa vektorn b med funktionsvärden av q (inre punkter i diskretiseringen)
xis = linspace(0+h,L-h,n)';
b = Q(xis) / k * h^2; % multiplicera med konstanter
% addera slut/startpunkter
b(1) = b(1) + t0;
b(end) = b(end) + t1;


%skapa matrisen A
A = diag(ones(1,n)*2,0) + diag(-1*ones(1,n-1),1) + diag(-1*ones(1,n-1),-1);

%% b)
clc;

% lös AT = b;
lT = A\b;

% lägg till start/slutvärden
T = [t0;lT;t1];
xs = [0;xis;L];

% plotta
figure(1);
plot(xs',T')
title(1,'temperatur över längd')

%% c)
clc;

iters = 10;

ans_3 = zeros(1,iters); % preallocata vektor för svar

start_n = 19;
n = start_n;
for i = 1:iters

    % lös problemet för olika h-värden
    h = L/(n+1);
    xis = linspace(0+h,L-h,n)';
    b = Q(xis) / k * h^2; 
    b(1) = b(1) + t0;
    b(end) = b(end) + t1;
    A = diag(ones(1,n)*2,0) + diag(-1*ones(1,n-1),1) + diag(-1*ones(1,n-1),-1);
    lT = A\b;

    index_3 = 3/h;

    ans_3(i) = lT(index_3);

    n = n*2 + 1; % halvera h
end

% bestäm det svar som hade 5 korrekta decimaler
errs = abs(ans_3(1,1:end-1)-ans_3(1,2:end));
index_precise_ans = find(errs < 0.5 * 10^-5,1,"first") + 1;
precise_ans = ans_3(index_precise_ans+3) % lägg till några iterationer för säkerhets skull, 833.134382316262

% bestäm noggranhetsordning
lower = ans_3(1,1:end-2);
mid = ans_3(1,2:end-1);
upper = ans_3(1,3:end);
ratios = (lower-mid)./(mid-upper);
approx_noggranhet = log2(ratios); % verkar vara 2
