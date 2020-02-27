function marca = extractdata(block)
    
    
    x = block(1:2049); %obtenemos la mitad del bloque de 4096
%     figure(4)
%     plot(abs(x))
    rng('default');
    rng(5); %semilla para los pseudorandon 
    w1 = randn(1,2049); % vector de numero random
    for k = 1:length(w1)
        if w1(k) < 0
            w(k) = -1;
        else
            w(k) = 1;
        end
    end
    mag = abs(x); 
    
    
%       CEPSTRUM   
      mag2= dct(mag);
      mag2(1:20)=0;
      mag =idct(mag2);     
     
    %Calculo del simbolo que se decodificara
    if sum((mag.*w/length(x))) < 0
        marca = -1;
    else
        marca = 1;
    end  
    
end