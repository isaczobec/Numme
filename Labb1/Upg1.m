% KÖR SECTIONENS I KONSEKVENT ORDNING
%% a)
clearvars,clc,close all;
% definiera funktion
f = @(x) x.^2 - 8*x - 12*sin(3*x + 1) + 19;
dfdx = @(x) 2*x - 8 - 36*cos(3*x + 1);
d2fdx2 = @(x) 2 + 36*3*sin(3*x+1);

amount_points = 800;

a = -10; b = 20; % definiera interval
xs = linspace(a,b,amount_points);
ys = f(xs); % beräkna funktionsvärden

plot(xs,ys); hold on; plot([a,b],[0,0]); % plotta grafen och y=0

% hitta interval för lösningar
ys1 = ys(1:end-1);
ys2 = ys(2:end);
signs = ys1.*ys2;
rootindicies = find(signs < 0);
% hitta start- och slutinterval [a,b]
as = xs(1,rootindicies);
bs = xs(rootindicies+1);
% hitta mittpunkter och max errors, är halva intervallet
midpoints = (as + bs)/2;
maxerrors = abs(as-bs)/2;

% ger approximativa rötter vid x=1.9587 2.6721 3.9487 4.8123 6.2015 6.6521
% med max absolut fel 0.0188

%% b)

clc;

g = @(x) (1/19)*(x.^2 + 11*x - 12*sin(3*x+1))+1;
% notera att g = f/19 + x
% alltså ger g(r) = r att f(r) = 0

% undersök vilka approximativa rötter som kan hittas med fpi genom att se vilka som har
% derivator vilka till beloppet är mindre än 1

dgdx = @(x) (1/19)*(2*x + 11 - 36*cos(3*x+1));
%approx_roots = [2,2.66,4,4.77,6.2,6.65];
approx_roots = midpoints
derivatives = dgdx(approx_roots)

% ger att 2, 4, 6.2 kan hittas med fpi
% (detta var inte empiriskt ): )


roots = zeros(1,length(approx_roots)); % pre-allocate array med rötter

% beräkna hur många iterationer som behövs för att (ungefär) få ett 
% fel < 10^-10 (ta med de som inte konvergerar för empiriska syften)
ns = ceil(abs((ones(1,length(maxerrors)) * log10(10^-10) - log10(maxerrors))./log10(abs(derivatives))));
ns = ns + 50 % lägg till godtycklig mängd iterationer för att vara på säkra sidan
   

for i = 1:length(approx_roots)
    roots(1,i) = fpi_method(g,approx_roots(1,i),ns(1,i),10e-11); % stopping criteria 10 gånger mindre för säkerhets skull
end


% kolla vilka startgissningar som kunde hittas med metoden
start_guess_tolerance = 0.1;
root_start_guess_difference = abs(approx_roots-roots);
could_be_found_vec = root_start_guess_difference < start_guess_tolerance;
found_indexes = find(could_be_found_vec);
found_roots = roots(found_indexes);
disp(['Hittade följande rötter: ',num2str(found_roots)])

roots

r1s = roots;


%% c)

clc;

approx_roots = midpoints

% approximera antalet iterationer som krävs för begärt fel
initial_errors = maxerrors;
desired_errors = ones(1,length(approx_roots)) * 10^-15; % -15 pga nästa deluppgift
err_mult = abs(d2fdx2(approx_roots)/ (2 * dfdx(approx_roots))); %% anta att derivatorna genom processen liknar de initiella värdena
ns = ceil(log2(log10(desired_errors) ./ (log10(err_mult) + 2*log10(initial_errors))) + 2); % beräkna antalet iterationer som krävs för varje rot
ns = ns+3 % extra iteration för kompensera för approximeringen av antal iterationer krävda

required_iterations = max(ns); % värden liknar varandra, välj max för simplifiera resten

roots = newtons_method(f,midpoints,required_iterations+1000,dfdx)


%% d) i

clc; close all;


x0 = approx_roots(1,1)
xi_newt = x0;
xi_fpi = x0;
r = roots(1,1)
n = 100;

errs = zeros(2,n);

% iterera n gånger och kom ihåg felet
for i = 1:n

    % record errors
    errs(1,i) = abs(xi_newt - r);
    errs(2,i) = abs(xi_fpi - r);

    xi_newt = xi_newt - (f(xi_newt)/dfdx(xi_newt));
    xi_fpi = g(xi_fpi);

end

xi_fpi
xi_newt

% prova att plotta formler för konvergensen
nits = 1:n;
newt_error = @(n,d,ie) d.^(2.^(n-2)) .* ie.^(2.^(n-1));
d = abs(d2fdx2(approx_roots)/ (2 * dfdx(approx_roots)));
ie = abs(x0 - r);
ne_mat = @(n) newt_error(n,d,ie);

n_err_vals = ne_mat(nits);

% plotta felen
figure(1);
semilogy(1:n,errs(1,1:end),'g'); 
hold on; 
semilogy(1:n,errs(2,1:end),'r');
hold on; 
semilogy(nits,n_err_vals,'b');

%% d) ii
% plotta konvergensen

newt_xs = errs(1,1:end-1);
newt_ys = errs(1,2:end);

fip_xs = errs(2,1:end-1);
fip_ys = errs(2,2:end);

figure(2);
loglog(newt_xs,newt_ys,'b.');
hold on;
loglog(fip_xs,fip_ys,'g.');

