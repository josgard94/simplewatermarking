%
%   Centro de Investigación y Estudios Avanzados del IPN 
%   Topicos Avanzado de Ingenieria Computacional
% 
%   Edgard José Diaz Tipacamu
%   ediaz@tamps.cinvestav.mx
%
%   En este archivo fuente se realizo la implementación de
%   de un esquema de marcado agua digital para audio.
clc;clear;close all;

addpath(genpath('PQevalAudio_2019'));

%Leer archivo de audio
[y,Fs] = audioread('audio001.wav');

%obtenemos el tamaño del vector
[n,~] = size(y);
b = [-1 -1 1 1 1 -1 -1 1 1];
m = 0;
contador = 1;
ban = 1;
%Extrahemos bloques de 4096 muestra  del audio
for k = 1:512:n-512
    
   block(k:(k+511)) = y(k:(k+511)); %calculamos la FDT a cada bloque    
   
   if contador == 1  
        new_y(k:(k+511)) = CodeSynchronize(block(k:(k+511)),Fs);
        contador = contador + 1;

   else
        if m ==length(b)
            m = 1;
            if ban == 1
                data = b;
                ban = 0;
            else
                data =[data,b];
            end
        else
            m = m + 1;
        end
        new_y(k:(k+511)) = watermarking(fft(block(k:(k+511))),b(m));
        contador = contador + 1;
        if contador > 10
            contador = 1;
        end
   end
end
ODG = Objetive_Difference_Grade(real(new_y),y);
audiowrite('marcado2.wav',real(new_y),Fs);
sound(real(new_y),Fs);
save('data.mat','data');
