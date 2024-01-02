function [Img_vectP, EQM, somme_autresValeursP, vpP, vecteur_propre_max] = projection(Img, L)

    T = func2D_3D(Img, L, L);
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
    
    
    for k = 1:20
        nb_vecteurs_propres = k;
        Img_vectP = zeros(L, L, nb_vecteurs_propres);
        maxP = vpP(end-(nb_vecteurs_propres-1):end);
        
        
        for i = 1:length(maxP)
            [indice_ligne, indice_colonne] = find(P == maxP(i));
            vecteur_propre_max(i,:) = Lv(:, indice_colonne);
        end
        
        Img_vectP(1, :, 1:nb_vecteurs_propres) = vecteur_propre_max(1:nb_vecteurs_propres, 1:L)';
        for i = 1:L-1
            Img_vectP(i+1, :, 1:nb_vecteurs_propres) = vecteur_propre_max(1:nb_vecteurs_propres, i*L+1:(i+1)*L)';
        end
        
        mean_quadratic = v(end-(nb_vecteurs_propres-1):end,:) - vecteur_propre_max;
        EQM(k) = mean(mean_quadratic(:).^2);
    
        autres_vectP = vpP(end-L*L+1:end-(nb_vecteurs_propres));
        somme_autresValeursP(k) = sum(autres_vectP);
    end
end