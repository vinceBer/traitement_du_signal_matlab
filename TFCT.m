function D = TFCT(x, Nfft, Nwin, hop) 

% D = TFCT(x,Nfft,win,hop)     
% Transform�e de Fourier � court terme (TFCT)
%
% x : signal dont on veut calculer la TFCT
% Nfft : nombre de points pour la FFT
% Nwin : nombre de points de la fen�tre de pond�ration
% hop : nombre de points de recouvrement des fen�tres
%
% D : r�sultat de la TFCT   
% Chaque colonne de D est le r�sultat de la TFD sur f points d'une portion
% de x (chaque colonne repr�sente une trame)
%
% Programme largement inspir� de celui de D. Marshall 


% On met x sous forme de vecteur ligne
if size(x,1) > 1
  x = x';
end

%initialisation des param�tres
N = length(x);
c = 1;

%cr�ation de la fen�tre de pond�ration
    if rem(Nwin, 2) == 0   
      Nwin = Nwin + 1;  %pour avoir un nombre impair d'�chantillons
    end
    halflen = (Nwin-1)/2;
    halff = Nfft/2;   % point central de la fen�tre
    halfwin = 0.5 * ( 1 + cos( pi * (0:halflen)/halflen));
    win = zeros(1, Nfft);
    acthalflen = min(halff, halflen);
    win((halff+1):(halff+acthalflen)) = halfwin(1:acthalflen);
    win((halff+1):-1:(halff-acthalflen+2)) = halfwin(1:acthalflen);


% initialisation de la sortie
d = zeros((1+Nfft/2),1+fix((N-Nfft)/hop));

%Calcul
for b = 0:hop:(N-Nfft)
  u = win.*x((b+1):(b+Nfft));
  t = fft(u);
  d(:,c) = t(1:(1+Nfft/2))';
  c = c+1;
end;

 D = d;
end
