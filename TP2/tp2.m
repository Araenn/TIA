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

T = func2D_3D(I_norm, L, L);

%% base karhunen loeve
for i = 1:length(T)
    a = T(:,:,i);
    v(i, :) = a(:);
end

M = zeros(size(v,2));
for i = 1:size(v,1)
    M = M + v(i,:).' * v(i,:);
end
M = M/(size(v,2));
[Lv, P] = eig(M);
vpP = sort(P(:));
maxP = vpP(end-3:end);

for i = 1:length(maxP)
    [indice_ligne, indice_colonne] = find(P == maxP(i));
    vecteur_propre_max(i,:) = Lv(:, indice_colonne);
end

Img_vectP1(1,:) = vecteur_propre_max(1, 1:L);
Img_vectP2(2,:) = vecteur_propre_max(2, 1:L);
Img_vectP1(3,:) = vecteur_propre_max(3, 1:L);
Img_vectP1(4,:) = vecteur_propre_max(4, 1:L);
for i = 2:L
    Img_vectP1(i,:) = vecteur_propre_max(1, i:i+L-1);
    Img_vectP2(i,:) = vecteur_propre_max(2, i:i+L-1);
    Img_vectP3(i,:) = vecteur_propre_max(3, i:i+L-1);
    Img_vectP4(i,:) = vecteur_propre_max(4, i:i+L-1);
end

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
dynam = [min(min(Img_vectP1)) max(max(Img_vectP1))];
mesh(Img_vectP1')
colorbar

subplot(2,2,2)
dynam = [min(min(Img_vectP2)) max(max(Img_vectP2))];
mesh(Img_vectP2')
colorbar

subplot(2,2,3)
dynam = [min(min(Img_vectP3)) max(max(Img_vectP3))];
mesh(Img_vectP3')
colorbar

subplot(2,2,4)
dynam = [min(min(Img_vectP4)) max(max(Img_vectP4))];
mesh(Img_vectP4')
colorbar