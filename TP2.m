clc; clear; close all

%% Création de g, image bruitée
img = im2double(rgb2gray(imread("lena_std.tif")));
n = length(img);

figure(1)
imshow(img)
title("Image originale")

% ajout de flou type "mouvement"
theta = 0;
len = 40;
figure(2)
FM = fspecial("motion", len, theta);
img_motion = imfilter(img, FM, "conv", "circular");

imshow(img_motion)
title("Image floutée type mouvement")

% ajout de bruit
sigma = 0;
varbruit = 10^-6;
img_bruitee = imnoise(img_motion, "gaussian", sigma, varbruit);

figure(3)
imshow(img_bruitee)
title("Image bruitée")

%% Restauration

% filtre inverse
img_restaur = deconvwnr(img_bruitee, FM);

figure(4)
imshow(img_restaur)
title("Filtre inverse")

% filtre wiener simplifié
vect_img = img(:);
var_img = var(vect_img);
snr = varbruit / var_img;
img_wiener_simpl = deconvwnr(img_bruitee, FM, snr);

figure(5)
imshow(img_wiener_simpl)
title("Filtre de Wiener simplifié")


% estimation snr

erreur_theorique = norm(abs(vect_img - img_wiener_simpl(:)));
erreur_temp = erreur_theorique;
erreur = erreur_temp;
K = 0;
delta = 0.01;
i = 0;
epsilon = 10^-9;
while (erreur > epsilon)
    i = i + 1;
    K = K + delta;
    tabK(i) = K;
    img_wiener_estim = deconvwnr(img_bruitee, FM, K);
    img_wiener_estim_flou = imfilter(img_wiener_estim, FM, "conv", "circular");
    r = img_bruitee - img_wiener_estim_flou;

    erreur = abs(( norm((r(:))) / (length(r(:)) - 1) ) - varbruit);
    tabE(i) = erreur;
    
    if erreur > erreur_temp
        delta = -delta / 2;
    end
    erreur_temp = erreur;
end

figure(6)
imshow(img_wiener_estim)
title("Filtre de wiener estimé")

figure(7)
plot(tabK)
hold on
plot(tabE)
grid()
legend("K", "Erreur")

% Wiener convergence
bruit = varbruit * randn(n,n);
Sbb = fftshift(abs(fft2(bruit)).^2);
Sss = fftshift(abs(fft2(img)).^2);
Rbb = ifft2(Sbb);
Rss = ifft2(Sss);
img_wiener = deconvwnr(img_bruitee, FM, Rbb, Rss);

figure(8)
imshow(img_wiener)