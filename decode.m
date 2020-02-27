%
%   Centro de Investigación y Estudios Avanzados del IPN 
%   Topicos Avanzado de Ingenieria Computacional
% 
%   Edgard José Diaz Tipacamu
%   ediaz@tamps.cinvestav.mx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc; close all;

%Cargar audio marcado
[y,Fs] = audioread('../marcado2.wav');
y = y(58462:end);
[n,~] = size(y);

%Adición de ruido gaussiano awgn(Señal,SNR en db,'measured',seed)
%y = awgn(y,30,'measured',3);


inicio = 1;
fin = 512;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Señal piloto  de referencia para resincronizar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = 0:1/Fs:0.092880;
% w = 21.5;
% SignalReferencs = 0.004*(sin(2*pi*w*t));
% SignalReferencs = SignalReferencs';
rand( 'seed', 5 ); 
SignalReferencs = 0.4 * ( rand(512,1) - 0.5 ); %Vector columna  de 16284 x 1

Signal = y(inicio:fin);
aux = Signal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Busqueda del código de sincronización
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for i = 1:length(y)-512
    
    %proceso de blanqueamiento de la señal
    
    Signal = whitening(Signal,1);
    
    %Calculo de correlación de la señal de entrada con la de referenecia
    cor =  corr(SignalReferencs(1:512),Signal);
    %plot(Signal);
    if cor < 0.35
        Signal = zeros(1,512);
        inicio = inicio + 1;
        fin = fin + 1;
        Signal = y(inicio:fin);
    else
        toc;
        figure(1)
        subplot(2,1,1);
        plot(aux);
        title('señal desincronizada')
        xlabel('Muestras');
        ylabel('Amplitud');
        subplot(2,1,2);
        plot(y(inicio:fin));
        hold on;
        plot(SignalReferencs);
        title('señal sincronizada')
        xlabel('Muestras');
        ylabel('Amplitud');
        y = y(inicio:end);
        break;
    end
end


contador = 1;
p = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Extracción  de la marca de agua.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:4096:length(y)-4096
    if contador == 1
        contador = contador + 1;
    else
        block(k:(k+4095)) = fft(y(k:(k+4095)));
        data2(p) = extractdata(block(k:(k+4095)));
        p = p + 1;
        contador = contador + 1;
        if contador > 10
            contador = 1;
            %p = 1;
            
        end
    end
end

%cargar vector de datos insertados originalmente a la señal

load('../data.mat')
if length(data) < length(data2)
    data2 = data2(1:90);
end
data = data(1:length(data2));

%Conversion de los vectores en vectores logicos
X = data > 0;
Y = data2 > 0;

%Calculo   del BER
[number,ratio] = biterr(Y,X);
fprintf('\n');
d = strcat('BER: ',num2str(ratio));
disp(d)
fprintf('\n');
d = strcat('Errors: ',num2str(number));
disp(d)