function e = whitening(block,caso)
    switch(caso)
        case 1 %Blanqueamiento con DCT
            vec = ones(1,length(block));
            for i = 1:80
               vec(i) = 0;
            end

            y = dct(block);
            y = vec'.*y;
            e = idct(y);
         
        case 2 %Blanqueamiento con filtro de mediana
            y = medfilt1(block,5);
            e = block - y;
        case 3
            windowSize = 2; 
            b = (1/windowSize)*ones(1,windowSize);
            a = 1;
            y = filter(b,a,block);
            e = block - y;
        case 4 %Blaquemiento con filtrado de savinzky
            order = 9; %el grado debe ser menor al tamaño de ventana
            framelen = 11; %Tamaño de la ventana debe ser impar
            y = sgolayfilt(block,order,framelen);
            e = block - y;
            
        otherwise
    end
end