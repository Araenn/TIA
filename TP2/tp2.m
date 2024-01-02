clc; clear; close all

N = 256;
p = 5;
L = 2*p+1;
a = 4;
b = 4;
r = 0.9; %coeff correlation compris entre -1 et 1;

x0 = (-p:p)';
y0 = (-p:p)';

%% creation masque
terme1 = [x0 y0];
terme2 = [1/a^2 -r/(a*b); -r/(a*b) 1/b^2];
M = exp( -(1/(2*(1-r^2))) * terme1 * terme2 * terme1');

A = randn(N, N);

I = filter2(M, A);

%% normalisation texture
I_cut = I(p+1:end-(p+1),p+1:end-(p+1));
I_norm = I_cut - mean(I_cut(:));
I_norm = I_norm/std(I_norm(:));

sigma = sqrt(1/4);
bruit = sigma * randn(size(I_cut));

I_norm_bruit = I_norm + bruit;

%% base karhunen
[Img_vectP, EQM, somme_autresValeursP, vpP, vecteur_propre_max] = projection(I_norm, L);
[Img_vectP_bruit, EQM_bruit, somme_autresValeursP_bruit, vpP_bruit, vecteur_propre_max_bruit] = projection(I_norm_bruit, L);

%% affichage
figure(1)
dynam = [min(min(I)) max(max(I))];
imshow(I, dynam)
colorbar
title("Image")

figure(2)
dynam = [min(min(I_cut)) max(max(I_cut))];
imshow(I_cut, dynam)
colorbar
title("Image sans bord")

figure(3)
dynam = [min(min(I_norm)) max(max(I_norm))];
imshow(I_norm, dynam)
colorbar
title("Image normalisée")

figure(4)

subplot(2,2,1)
dynam = [min(min(Img_vectP(:,:,1))) max(max(Img_vectP(:,:,1)))];
mesh(Img_vectP(:,:,1)')
colorbar

subplot(2,2,2)
dynam = [min(min(Img_vectP(:,:,2))) max(max(Img_vectP(:,:,2)))];
mesh(Img_vectP(:,:,2)')
colorbar

subplot(2,2,3)
dynam = [min(min(Img_vectP(:,:,3))) max(max(Img_vectP(:,:,3)))];
mesh(Img_vectP(:,:,3)')
colorbar

subplot(2,2,4)
dynam = [min(min(Img_vectP(:,:,4))) max(max(Img_vectP(:,:,4)))];
mesh(Img_vectP(:,:,4)')
colorbar
sgtitle("Vecteurs propres des 4 plus grandes valeurs propres")


minEQM = min(EQM);
maxEQM = max(EQM);
figure(5)
plot(EQM)
hold on
plot(normalize(somme_autresValeursP, "range", [minEQM, maxEQM]))
grid()
legend("EQM sur les dernières réalisations de v", "Somme autres valeurs propres non retenues")
title("Comparaison EQM et somme pour vecteurs propres entre 1 et 20")
xlabel("Nombre de vecteurs propres retenus")

figure(6)
dynam = [min(min(I_norm_bruit)) max(max(I_norm_bruit))];
imshow(I_norm_bruit, dynam)
colorbar
title("Image normalisée bruitée")

figure(7)

subplot(2,2,1)
dynam = [min(min(Img_vectP_bruit(:,:,1))) max(max(Img_vectP_bruit(:,:,1)))];
mesh(Img_vectP_bruit(:,:,1)')
colorbar

subplot(2,2,2)
dynam = [min(min(Img_vectP_bruit(:,:,2))) max(max(Img_vectP_bruit(:,:,2)))];
mesh(Img_vectP_bruit(:,:,2)')
colorbar

subplot(2,2,3)
dynam = [min(min(Img_vectP_bruit(:,:,3))) max(max(Img_vectP_bruit(:,:,3)))];
mesh(Img_vectP_bruit(:,:,3)')
colorbar

subplot(2,2,4)
dynam = [min(min(Img_vectP_bruit(:,:,4))) max(max(Img_vectP_bruit(:,:,4)))];
mesh(Img_vectP_bruit(:,:,4)')
colorbar
sgtitle("Vecteurs propres des 4 plus grandes valeurs propres avec bruit")


minEQM = min(EQM_bruit);
maxEQM = max(EQM_bruit);
figure(8)
plot(EQM_bruit)
hold on
plot(normalize(somme_autresValeursP_bruit, "range", [minEQM, maxEQM]))
grid()
legend("EQM sur les dernières réalisations de v", "Somme autres valeurs propres non retenues")
title("Comparaison EQM et somme pour vecteurs propres entre 1 et 20 avec bruit")
xlabel("Nombre de vecteurs propres retenus")

figure(9)
diff_valeurP = normalize(abs(vpP(end-L*L+1:end) - vpP_bruit(end-L*L+1:end)), "range", [0 1]);
diff_vectP = normalize((abs(vecteur_propre_max_bruit - vecteur_propre_max)), "range", [0 1]);
subplot(2,1,1)
plot(diff_valeurP, 'o')
grid()
xlabel("nombre de valeurs propres")
ylabel("Différence")
title("Valeurs propres")
subplot(2,1,2)
mesh(diff_vectP)
zlabel("Différence")
ylabel("nombre de vecteurs de la base")
xlabel("nombre de valeurs propres")
title("Vecteurs propres")
sgtitle("Différence entre valeurs propres avec et sans bruit")