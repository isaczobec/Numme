%% a)
clearvars;close all;clc;

load eiffel1.mat
n = length(A)/2;



% belasta nod 1 med kraft högerut
test_force = zeros(2*n,1);
test_force(1) = 100;

% lös ekvationssystemet, bel blir förskjutningar (x1,y1,x2,y2)
bel = A\test_force;

% addera förskjutningarna till positionerna
bel_x_nod = xnod + bel(1:2:end);
bel_y_nod = ynod + bel(2:2:end);

% plotta förskjutningen
trussplot(xnod,ynod,bars); hold on;
trussplot(bel_x_nod,bel_y_nod,bars); hold on;
plot(bel_x_nod(1),bel_y_nod(1),'.'); hold on;

%% b)

filenames = {'eiffel1.mat','eiffel2.mat','eiffel3.mat','eiffel4.mat'};
len_mats = length(filenames);
antal_hl = 2;

% preallocata times
times = zeros(1,len_mats);
amount_iterations = 20;

for i = 1:len_mats
    load(filenames{i});
    n = length(A)/2;
    b = randn(2*n,antal_hl);

    for j = 1:amount_iterations
        % lös och mät tid
        tic;
        belastningar = A\b;
        times(i) = times(i) + toc;
    end

end

times = times / amount_iterations;

semilogy(1:len_mats,times);

%% c)
clc; close all;


load('eiffel1.mat');
n = length(A)/2;
B = zeros(2*n,n);

% definiera alla förskjutningsvektorer som kolonvektorer i en matris
for i = 1:n
    B(i*2,i) = -1;
end

% lös ekvationssystemet
X = A\B;

colvectors = num2cell(X',2);

norms = zeros(1,n);
for i = 1:n
    norms(i) = norm(colvectors{i});
end

[M,I] = max(norms)
[m,i] = min(norms)

trussplot(xnod,ynod,bars);hold on;
plot(xnod(I),ynod(I),'ro');hold on;
plot(xnod(i),ynod(i),'g*');hold on;


%% c) resten

% beräkna exekveringstider

filenames = {'eiffel1.mat','eiffel2.mat','eiffel3.mat','eiffel4.mat'};
len_mats = length(filenames);

load('ex_times.mat') % ladda in exekveringstider

% iterera över alla storlekar av modellen
for i = 1:len_mats
    load(filenames{i});
    n = length(A)/2;

    % lös naiv
    % -------------- KOMMENTERAD UT RN EFTERSOM TAR VÄLDIGT LÅNG TID
    %{
    tic;
    % definiera vektorer
    forskjutningar = zeros(1,n);
    for j = 1:n
        bel = zeros(2*n,1);
        bel(j*2) = -1;
        x = A\bel;
        forskjutningar(j) = norm(x);
        % uppdatera max
        
    end
    m = max(forskjutningar)
    times(i,1) = toc;
    %}

    % lös LU
    % -------
    tic;
    B = zeros(2*n,n);
    
    % definiera alla förskjutningsvektorer som kolonvektorer i en matris
    for j = 1:n
        B(j*2,j) = -1;
    end
    
    % lös ekvationssystemet
    X = A\B;

    % dela upp i kolonnvektorer och hitta 
    colvectors = num2cell(X',2);
    norms = zeros(1,n);
    for j = 1:n
        norms(j) = norm(colvectors{j});
    end
    [M,I] = max(norms)

    times(i,2) = toc;

    % lös Sparse
    % -------

    tic;
    As = sparse(A);
    % definiera vektorer
    forskjutningar = zeros(1,n);
    for j = 1:n
        bel = zeros(2*n,1);
        bel(j*2) = -1;
        x = As\bel;
        forskjutningar(j) = norm(x);
        % uppdatera max
        
    end
    m = max(forskjutningar)
    times(i,3) = toc;


    % lös Sparse LU
    % -------
    tic;
    As = sparse(A);
    B = zeros(2*n,n);
    
    % definiera alla förskjutningsvektorer som kolonvektorer i en matris
    for j = 1:n
        B(j*2,j) = -1;
    end
    
    % lös ekvationssystemet
    X = As\B;

    % dela upp i kolonnvektorer och hitta 
    colvectors = num2cell(X',2);
    norms = zeros(1,n);
    for j = 1:n
        norms(j) = norm(colvectors{j});
    end
    [M,I] = max(norms)

    times(i,4) = toc;
    
    save ex_times.mat times % spara efter varje storlek för att sava gjort arbete

end