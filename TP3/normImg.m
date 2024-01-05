function I_norm = normImg(I)
    I_norm = I - mean(I(:));
    I_norm = I_norm/std(I_norm(:));
end