%
%   Centro de Investigación y Estudios Avanzados del IPN 
%   
% 
%   Edgard José Diaz Tipacamu
%   ediaz@tamps.cinvestav.mx
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc; close all; %clean work space

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pilot signal for synchronization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% t = 0:1/Fs:0.092880;
% w = 21.5;
% SignalReferencs = 0.004*(sin(2*pi*w*t));
% SignalReferencs = SignalReferencs';
rand( 'seed', 5 ); 
SignalReferencs = 0.4 * ( rand(512,1) - 0.5 ); %pseudorandom vector or synchronization code 


%read marked audio file 
[y,Fs] = audioread('../marcado2.wav');
y = y(58462:end); %change signal start to simulate synchronization problem
[n,~] = size(y); % signal size

%control index to traverse the audio signal and search the synchronization code
inicio = 1;
fin = 4096;
Signal = y(inicio:fin); %4096 audio sample window to search the synchronization code.


aux = Signal;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   search synchronization code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for i = 1:length(y)-4096
    
    %Signal whitening
    Signal = whitening(Signal,1);
    
    %correlation between the marked audio signal and the reference signal
    cor =  corr(SignalReferencs(1:4096),Signal);
    %plot(Signal);
    if cor < 0.35
        Signal = zeros(1,4096);
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
%   watermark extraction  loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k = 1:4096:length(y)-4096
    if contador == 1
        contador = contador + 1;
    else
        block(k:(k+4095)) = fft(y(k:(k+4095)));
        data2(p) = extractdata(block(k:(k+4095))); %data hidden extraction
        p = p + 1;
        contador = contador + 1;
        if contador > 10
            contador = 1;
            %p = 1;
            
        end
    end
end

%load the vector of data that was embedded in the carrier signal
load('../data.mat')

if length(data) < length(data2)
    data2 = data2(1:90);
end
data = data(1:length(data2));

%change vectors to logical vectors
X = data > 0;
Y = data2 > 0;

%calculate bit error ratio
[number,ratio] = biterr(Y,X);
fprintf('\n');
d = strcat('BER: ',num2str(ratio));
disp(d)
fprintf('\n');
d = strcat('Errors: ',num2str(number));
disp(d)
