clc; clear; close all

N = 4096;
U = randn(N, 1);
dt = 1;
t = (0:dt:N-1)';
fe = 1/dt;

%% partie 1
fc1 = (1/3) * (fe/2);
fc2 = (2/3) * (fe/2);
longFiltre = 32;
h = fir1(longFiltre-1, 2.*[fc1, fc2], "bandpass");

T = filter(h, 1, U);
T = T - mean(T);
T = T/std(T);

fftT = abs(fft(T));

% ou utiliser reshape
s = zeros(N/16, 16);
s(1,:) = T(1:16);
for i = 2:N/16
    m = 16*i;
    n = m-16+1;
    s(i,:) = T(n:m);
end
S = s;

dspS = abs(fft(S).^2);
moyenneDspS = mean(dspS);

%% partie 2
M = zeros(16);
for i = 1:N/16
    M = M + S(i,:).' * S(i,:);
end
M = M/(N/16);
[L, P] = eig(M);
maxP = max(P(:));
[indice_ligne, indice_colonne] = find(P == maxP);
vecteur_propre_max = L(:, indice_colonne);

mean_quadratic = mean((S * vecteur_propre_max).^2);

%% partie 3
epsilon = (0:0.001:0.1)';
for j = 1:length(epsilon)
    fc1 = (1/3) * (fe/2) - epsilon(j);
    fc2 = (2/3) * (fe/2) + epsilon(j);
    longFiltre = 32;
    h2 = fir1(longFiltre-1, 2.*[fc1, fc2], "bandpass");
    
    nouveauT = filter(h2, 1, U);
    nouveauT = nouveauT - mean(nouveauT);
    nouveauT = nouveauT/std(nouveauT);
    
    fftNouveauT = abs(fft(nouveauT));
    
    % ou utiliser reshape
    sN = zeros(N/16, 16);
    sN(1,:) = nouveauT(1:16);
    for i = 2:N/16
        m = 16*i;
        n = m-16+1;
        sN(i,:) = nouveauT(n:m);
    end
    nouveauS = sN;
    
    nouveelleDspS = abs(fft(nouveauS).^2);
    nouvelleMoyenneDspS = mean(nouveauS);
    
    nouveauM = zeros(16);
    for i = 1:N/16
        nouveauM = nouveauM + nouveauS(i,:).' * nouveauS(i,:);
    end
    nouveauM = nouveauM/(N/16);
    [L, P] = eig(nouveauM);
    nouveauMaxP(j) = max(P(:));
    
    nouvelleMean_quadratic(j) = mean((nouveauS * vecteur_propre_max).^2);
end
%% affichage

figure(1)
plot(t, T)
title('Signal T')

f = (0:1/(N-1):fe/2)';

figure(2)
stem([fe/6, (2*fe)/6], [fe/6, (2*fe)/6],'b')
hold on
plot(f, fftT(1:N/2))
title('Transformée de Fourier du signal T')
grid()
legend("fc1, fc2", "Spectre de T")

figure(3)
plot(moyenneDspS)
title('Moyenne de la DSP de S')
grid on

figure(4)
scatter(epsilon, nouveauMaxP)
hold on
scatter(epsilon, nouvelleMean_quadratic)
grid on
legend("Nouvelle plus grande valeur propre", "Nouvelle MQ sur l'ancienne projection")
title("Optimalité")