function marcado = CodeSynchronize(bloque,fs)

%   t = 0:1/fs:0.092880;
%   w = 21.5;
%   y =0.004* (sin(2*pi*w*t));
%   plot(y);
%   
%   newBloque = y(1:4096);
%   marcado = newBloque + bloque;%ifft(x);  %aplicamos la  ifft para regresar al dominio del  tiempo.
% 
rand( 'seed', 5 ); 
y = 0.4 * ( rand(512,1) - 0.5 )'; %Vector columna  de 16284 x 1

marcado = y + bloque;
end
