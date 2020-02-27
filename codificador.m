%
%   Centro de Investigación y Estudios Avanzados del IPN 
%   
%
%   Date: Fabruary 2020
%   Edgard José Diaz Tipacamu
%   ediaz@tamps.cinvestav.mx
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all; %clean work space

%read  audio file or signal carrier
[y,Fs] = audioread('audio001.wav');

%read  size  from vector audio
[n,~] = size(y);

%create a vector symbols from to insert in the  signal carrier
b = [-1 -1 1 1 1 -1 -1 1 1];
m = 0;
contador = 1;
ban = 1;

%segmenting the audio file into blocks of 4096 samples, start of the watermark embedding loop.
for k = 1:4096:n-4096
   %A synchronization frame is inserted every nine watermark blocks. That is, macro blocks of 10 x 4096 are
   %created where the first corresponds to the synchronization code. 
   
   block(k:(k+4095)) = y(k:(k+4095)); %calculate the FFT to audio blocks
   
   if contador == 1  
        new_y(k:(k+4095)) = CodeSynchronize(block(k:(k+4095)),Fs); %insert one synchronization frame  on the first block the audio
        contador = contador + 1;
   else
        if m ==length(b)
            m = 1;
            %create a vector with the information embedding on the host signal.
            if ban == 1
                data = b;
                ban = 0;
            else
                data =[data,b];
            end
        else
            m = m + 1;
        end
        new_y(k:(k+4095)) = watermarking(fft(block(k:(k+4095))),b(m));%embedding of the watermark in the audio block.
        contador = contador + 1;
        if contador > 10
            contador = 1;
        end
   end
end

audiowrite('marcado2.wav',real(new_y),Fs);%save marked audio file
save('data.mat','data'); %save file containing the data vector inserted in the host signal
