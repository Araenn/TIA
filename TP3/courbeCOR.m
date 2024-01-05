function [Pd, Pfa] = courbeCOR(seuilCOR, I2fp, posTexture2)

    for i = 1:length(seuilCOR)
        Is = double(I2fp >= seuilCOR(i));
    
        bonnes_det = (Is == 1) & (posTexture2 == 1);
    
        nombre_vrais_positifs = sum(bonnes_det(:));
    
        nombre_total_cibles_presentes = sum(posTexture2(:) == 1);
        
        Pd(i) = nombre_vrais_positifs / nombre_total_cibles_presentes;
        
        % Calcul de Pfa (probabilité de fausse alarme)
        nombre_vrais_negatifs = sum(Is(:) == 0 & posTexture2(:) == 0);
    
        nombre_total_cibles_absentes = sum(posTexture2(:) == 0);
        
        Pfa(i) = 1 - (nombre_vrais_negatifs / nombre_total_cibles_absentes); % 1 - proba manque
    end
end