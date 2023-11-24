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

%% nomralisation texture


dynam = [min(min(I)) max(max(I))];
imshow(I, dynam)
colorbar