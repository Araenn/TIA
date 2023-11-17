clc; clear; close all

n = 200; %taille image

choix = menu("Choisir une image", "Point", "Disque", "Ligne", "Fente");
image = zeros(n);

if choix == 1
    choix_point = menu("Nombre de points", "1", "2");
    if choix_point == 1
        image(n/2, n/2) = 1;
    else
        image(n/4,n/4) = 1;
        image(3*n/4, 3*n/4) = 1;
    end
elseif choix == 2
    choix_disque = menu("Choix du rayon", "5", "30");
    if choix_disque == 1
        rayon = 5;
    else
        rayon = 30;
    end
    centre_x = n/2;
    centre_y = n/2;
    
    [X, Y] = meshgrid(1:n, 1:n); % permet de creer coordonnees 2d, et donc pas besoin de boucle
    indices = (X - centre_x).^2 + (Y - centre_y).^2 <= rayon^2; % equation cercle
    image(indices) = 1; % cree disque la ou equation respectee
elseif choix == 3
    choix_ligne = menu("Choix du nombre de lignes", "1", "4");
    if choix_ligne == 1
        image(n/2, :) = 1; % ligne horizontale = indice (n/2,:), sinon (:,n/2)
    else
        offset = 20;
        image = zeros(n);
        image(:, n/4 - offset) = 1;
        image(:, n/2 - offset) = 1;
        image(:, 3*n/4 - offset) = 1;
        image(:, n - offset) = 1;
    end
else
    choix_fente = menu("Choix du nombre de fentes", "1", "2");
    largeur = 50;
    longueur = n - n/4;
    if choix_fente == 1
        image(centre_x - largeur:longueur, centre_y - largeur) = 1;
    else
        image(centre_x - largeur:longueur, centre_y - largeur) = 1;
        image(centre_x - largeur:longueur, centre_y + largeur) = 1;

    end
end

%% TF 2D
image_choisie = image;
figure(1)
imshow(image_choisie)
colorbar
title("Image originale")

[image_matlab, image_originale] = tf2d(image_choisie);

%% Différence

module_image = abs(image_originale);
module_matlab = abs(image_matlab);

difference = max(max(module_image - module_matlab))