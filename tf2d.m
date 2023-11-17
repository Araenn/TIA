function [fonction, new_image] = tf2d(image, dynam)
    fftrow = fft(image, [], 1); %premiere fft
    new_image = real(fft(fftrow, [], 2)); %fft sur le reste

    dynam = [0 max(max(new_image))];
    
    figure(2)
    subplot(2,1,1)
    imshow(image)
    colorbar
    title("Image originale")
    
    subplot(2,1,2)
    imshow(fftshift(new_image), dynam)
    colorbar
    title("Nouvelle image")
    
    fonction = real(fft2(image));
    figure(3)
    subplot(2,1,1)
    imshow(fftshift(new_image), dynam) % frequence 0 extremite gauche
    colorbar
    title("Double fft")
    
    subplot(2,1,2)
    imshow(fftshift(fonction), dynam)
    colorbar
    title("Fonction fft2 de Matlab")