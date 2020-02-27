% En esta funcion se procesa un bloque de audio realizando 
% la inserccion de informacion dentro de la magnitud de un audio.
function marcado = watermarking(block,b)

    alpha = 0.5; %factor de robustez
    rng('default')
    rng(5); %semilla para los pseudorandon
    w1 = randn(1,257); % vector de numero random
    
    for k = 1:length(w1)
        if w1(k) < 0
            w(k) = -1;
        else
            w(k) = 1;
        end
    end
    
    x = block(1:257); %obtenemos la mitad del bloque de 4096
    mag = abs(x);      %se calcula la magnitud del nuevo bloque
    fase = angle(x);   %se calcula el angulo de phase del nuevo bloque
    magnitud = mag + ( alpha * w * b);  %insertamos la información en la magnitu
    new_y = (magnitud.* cos(fase) + (j * magnitud.* sin(fase)));  %reconstruimos la señal ya con la WM insertada    
    m = conj(new_y);    %obtenemos el conjugado de la nueva señal   
    x = [new_y,m(256:-1:2)]; %concatenamos el conjudado a la nueva señal para reconstruirla   
    marcado = ifft(x);  %aplicamos la  ifft para regresar al dominio del  tiempo.
    disp(b)
    
end