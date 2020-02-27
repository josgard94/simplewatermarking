%
%   Centro de Investigación y de Estudio Avazados del IPN
%
%
%   Date: Fabraury 2020
%   Edgard José Díaz Tipacamú
%   ediaz@tamps.cinvestav.mx
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function marcado = watermarking(block,b)

    alpha = 0.5; %robustness factor 
    
    rng('default')
    rng(5); %pseudoramdon seed
    w1 = randn(1,2049); % pseudorandom generator control seed
    
    %change the values of the vector in -1 and 1, where the position 
    %will take the value of one when the pseudorandom number is greater than 0, 
    %otherwise one less will be assigned.
    
    for k = 1:length(w1)
        if w1(k) < 0
            w(k) = -1;
        else
            w(k) = 1;
        end
    end
    
    x = block(1:2049); %we get half of the block
    mag = abs(x);      %calculate the magnitude of the vector
    fase = angle(x);   %the phase angle of the new block is calculated
    magnitud = mag + ( alpha * w * b);  %Embedding information  hidden in the magnitude of  elements of the audio block.
    new_y = (magnitud.* cos(fase) + (j * magnitud.* sin(fase)));  %rebuild marked audio signal  
    m = conj(new_y);    %calculate signal conjugate  
    x = [new_y,m(2048:-1:2)]; %concatenate  conjugate to the new signal to create the marked audio signal.
    marcado = ifft(x);  %calculate a inverse transformation FFT.
    disp(b); %print data embedding on the signal 
    
end
