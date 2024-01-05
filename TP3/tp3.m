clc; clear; close all

%% matrice covariance et texture interet
I = double(imread("Texture1.jpg"));
I_bruit = double(imread("Bruit_T1.jpg"));
I_T2 = double(imread("Texture2.jpg"));
I_T2_melange = double(imread("Texture2_T1.jpg"));

I_norm = normImg(I);
I_bruit = normImg(I_bruit);
I_T2 = normImg(I_T2);
I_T2_melange = normImg(I_T2_melange);


L = 11;
T = func2D_3D(I_norm, L, L);

for i = 1:length(T)
    a = T(:,:,i);
    v1(i, :) = a(:);
end

S1 = zeros(size(v1,2));
for i = 1:size(v1,1)
    S1 = S1 + v1(i,:).' * v1(i,:);
end
S1 = S1/(size(v1,2));

%% texture bruit correlation micro
[Lv, P] = eig(S1);
vpP = sort(P(:));
maxP = max(vpP);
[indice_ligne, indice_colonne] = find(P == maxP);
vecteur_propre_max = Lv(:, indice_colonne); % P

vecteur_propre_max = vecteur_propre_max / norm(vecteur_propre_max);
Img_vectP(1, :) = vecteur_propre_max(1:L)';
for i = 1:L-1
    Img_vectP(i+1, :) = vecteur_propre_max(i*L+1:(i+1)*L)';
end

I1f = filter2(Img_vectP, I_bruit);
I1fp = I1f.^2;
I1fp = I1fp / max(I1fp(:));

%% melange textures
T2 = func2D_3D(I_T2, L, L);

for i = 1:length(T2)
    a = T2(:,:,i);
    v2(i, :) = a(:);
end
S2 = zeros(size(v2,2));
for i = 1:size(v2,1)
    S2 = S2 + v2(i,:).' * v2(i,:);
end
S2 = S2/(size(v2,2));

[Lv2, P2] = eig(S2);
vpP2 = sort(P2(:));
maxP2 = max(vpP2);
[indice_ligne, indice_colonne2] = find(P2 == maxP2);
vecteur_propre_max2 = Lv2(:, indice_colonne2); % P

vecteur_propre_max2 = vecteur_propre_max2 / norm(vecteur_propre_max2);
Img_vectP2(1, :) = vecteur_propre_max2(1:L)';
for i = 1:L-1
    Img_vectP2(i+1, :) = vecteur_propre_max2(i*L+1:(i+1)*L)';
end


I_melange_filtree1 = filter2(inv(Img_vectP2), I_T2_melange);
I_melange_filtree2 = filter2(Img_vectP, I_melange_filtree1);
I2fp = I_melange_filtree2.^2;
maxI2fp = max(I2fp(:));
I2fp = I2fp / maxI2fp;

seuil = 0.05;
Is = double(I2fp >= seuil);

%% trace courbe COR
posTexture2 = double(imread("Imsansbruit.bmp")); % M, = 1 si texture 2 presente
seuilCOR = (exp(0:0.1:10) - 1) / (exp(10) - 1);

I_melange_filtree_2emeMethode = filter2(Img_vectP, I_T2_melange);

I2fp2 = I_melange_filtree_2emeMethode.^2;
maxI2fp2 = max(I2fp2(:));
I2fp2 = I2fp2 / maxI2fp2;

I_melange_filtree4 = filter2(Img_vectP2 - Img_vectP, I_T2_melange);
I2fp4 = I_melange_filtree4.^2;
I2fp4 = I2fp4 / max(I2fp4(:));

[Pd, Pfa] = courbeCOR(seuilCOR, I2fp, posTexture2);
[Pd2, Pfa2] = courbeCOR(seuilCOR, I2fp2, posTexture2);
[Pd4, Pfa4] = courbeCOR(seuilCOR, I2fp4, posTexture2);
%% affichage
figure(1)
dynam = [min(min(I_norm)) max(max(I_norm))];
imshow(I_norm, dynam)
colorbar
title("Image Texture1")

figure(2)
dynam = [min(min(Img_vectP)) max(max(Img_vectP))];
imshow(Img_vectP, dynam)
colorbar
title("Image vecteur propre P")

figure(3)
dynam = [min(min(I1f)) max(max(I1f))];
imshow(I1f, dynam)
colorbar
title("Image I1 filtrée par P")

figure(4)
dynam = [min(min(I_bruit)) max(max(I_bruit))];
imshow(I_bruit, dynam)
colorbar
title("Image bruitée T1")

figure(5)
dynam = [min(min(I1fp)) max(max(I1fp))];
imshow(I1fp, dynam)
colorbar
title("Image puissances locales T1")

figure(6)
dynam = [min(min(I_T2_melange)) max(max(I_T2_melange))];
imshow(I_T2_melange, dynam)
colorbar
title("Image T2 mélange T1")

figure(7)
dynam = [min(min(I_melange_filtree2)) max(max(I_melange_filtree2))];
imshow(I_melange_filtree2, dynam)
colorbar
title("Image filtrée T2 T1")

figure(8)
dynam = [min(min(I2fp)) max(max(I2fp))];
imshow(I2fp, dynam)
colorbar
title("Image puissances locales T2")

figure(9)
dynam = [min(min(Is)) max(max(Is))];
imshow(Is, dynam)
colorbar
title("Image binarisée Is")

figure(10)
imshow(posTexture2)
colorbar
title("Positions texture I1 dans I2")

figure(11)
plot(Pfa, Pd, 'o')
hold on
plot(Pfa2, Pd2, 'o')
plot(Pfa4, Pd4, 'o')
grid()
xlabel("Pfa")
ylabel("Pd")
legend("Inv(S2) puis S1", "Filtre S1", "S2 - S1")
title("Courbe COR I2 filtrée par 2 méthodes, selon les seuils")