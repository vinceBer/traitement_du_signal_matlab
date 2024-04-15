%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VOCODEUR : Programme principal réalisant un vocodeur de phase 
% et permettant de :
%
% 1- modifier le tempo (la vitesse de "prononciation")
%   sans modifier le pitch (fréquence fondamentale de la parole)
%
% 2- modifier le pitch 
%   sans modifier la vitesse 
%
% 3- "robotiser" une voix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Récupération d'un signal audio
%--------------------------------

 [y,Fs]=audioread('Diner.wav');   %signal d'origine
% [y,Fs]=audioread('Extrait.wav');   %signal d'origine
% [y,Fs]=audioread('Halleluia.wav');   %signal d'origine

% Remarque : si le signal est en stéréo, ne traiter qu'une seule voie à la
% fois
y = y(:,1);

% Courbes (évolution au cours du temps, spectre et spectrogramme)
%--------
% Ne pas oublier de créer les vecteurs temps, fréquences...

% pour le spectrogramme
window = 128; % Taille de la fenêtre pour le spectrogramme
overlap = 120; % Recouvrement entre les fenêtres
nfft = 128; % Points de la FFT pour chaque segment

% Créer des vecteurs 
N = length(y);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% TRACER LES COURBES : 
% Tracer l'évolution au cours du temps
figure('Name', 'Son original'); % 'Name' spécifie le nom de la figure;
subplot(4,1,1);
plot(t, y);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Évolution au cours du temps');

% Tracer le spectre
subplot(4,1,2);
Y = fftshift(abs((1/N)*fft(y))) ;
plot(f-Fs/2,Y)
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre');

% Tracer le spectrogramme
subplot(4,1,3);
spectrogram(y, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogramme');



% Ecoute
%-------
sound(y, Fs);
pause(7)

%%
%-------------------------------
% 1- MODIFICATION DE LA VITESSE
% (sans modification du pitch)
%-------------------------------
%% PLUS LENT
rapp = 2/3;   %peut être modifié
ylent = PVoc(y,rapp,1024); 

% initialisation :
%On change le nombre de points + ce que ça implique:
N = length(ylent);
t =[0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Courbes
%--------
% TRACER LES COURBES : 
% Tracer l'évolution au cours du temps
figure('Name', 'Son lent'); % 'Name' spécifie le nom de la figure;
subplot(4,1,1);
plot(t, ylent);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Évolution au cours du temps');

% Tracer le spectre
subplot(4,1,2);
Y = fftshift(abs((1/N)*fft(ylent))) ;
plot(f-Fs/2,Y)
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre');

% Tracer le spectrogramme
subplot(4,1,3);
spectrogram(ylent, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogramme');


% Ecoute
%-------
soundsc(ylent,Fs);
pause(7)




%
%% PLUS RAPIDE
rapp = 3/2;   %peut être modifié
yrapide = PVoc(y,rapp,1024); 

% Initialisation :
% on change le nombre de points +ce que ça implique :
N=length(yrapide);
t=[0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Courbes
%--------
figure('Name', 'Son rapide'); % 'Name' spécifie le nom de la figure;
subplot(4,1,1);
plot(t, yrapide);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Évolution au cours du temps');

% Tracer le spectre
subplot(4,1,2);
Y = fftshift(abs((1/N)*fft(yrapide))) ;
plot(f-Fs/2,Y)
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre');

% Tracer le spectrogramme
subplot(4,1,3);
spectrogram(yrapide, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogramme');



% Ecoute 
%-------
soundsc(yrapide,Fs);
pause(7)

%%
%----------------------------------
% 2- MODIFICATION DU PITCH
% (sans modification de vitesse)
%----------------------------------
% Paramètres généraux:
%---------------------
% Nombre de points pour la FFT/IFFT
Nfft = 256;

% Nombre de points (longueur) de la fenêtre de pondération 
% (par défaut fenêtre de Hanning)
Nwind = Nfft;

%% Augmentation 
%--------------
a = 2;  b = 3;  %peut être modifié
yvoc = PVoc(y, a/b,Nfft,Nwind);

% Ré-échantillonnage du signal temporel afin de garder la même vitesse
ypitcha = resample(yvoc,a,b);
%tempo = resample(yvoc,a,b);
%ypitcha = [tempo;zeros(length(y)-length(tempo),1)];

%Somme de l'original et du signal modifié
%Attention : on doit prendre le même nombre d'échantillons
%Remarque : vous pouvez mettre un coefficient à ypitch pour qu'il
%intervienne + ou - dans la somme...
% A FAIRE !
coeff = 1 ;
ypitcha = ypitcha * coeff ;

% Courbes
%--------
% Initialisation :
% on change le nombre de points +ce que ça implique :
N = length(ypitcha);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

% Courbes
%--------
figure('Name', 'Augmentation'); % 'Name' spécifie le nom de la figure;
subplot(4,1,1);
plot(t, ypitcha);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Évolution au cours du temps');

% Tracer le spectre
subplot(4,1,2);
Y = fftshift(abs((1/N)*fft(ypitcha))) ;
plot(f-Fs/2,Y)
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre');

% Tracer le spectrogramme
subplot(4,1,3);
spectrogram(ypitcha, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogramme');


% Ecoute
%-------
soundsc(ypitcha,Fs);
pause(7)

%% Diminution 
%------------

a = 3;  b = 2;   %peut être modifié
yvoc = PVoc(y, a/b,Nfft,Nwind); 

% Ré-échantillonnage du signal temporel afin de garder la même vitesse
ypitchb = resample(yvoc,a,b);
%tempo = resample(yvoc,a,b);
%ypitchb = [tempo;zeros(abs(length(y)-length(tempo)),1)];

%-------------------------------------------------------------
%Possibilité : Somme de l'original et du signal modifié
%par exemple pour faire un duo
%Attention : on doit prendre le même nombre d'échantillons pour faire la
%somme (--> tronquer le plus "long")
%Remarque : vous pouvez mettre un coefficient à ypitch pour qu'il
%intervienne + ou - dans la somme...
% A FAIRE !

% Courbes
%--------
% Initialisation :
% on change le nombre de points +ce que ça implique :
N = length(ypitchb);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

figure('Name', 'Diminution'); % 'Name' spécifie le nom de la figure;
subplot(4,1,1);
plot(t, ypitchb);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Évolution au cours du temps');

% Tracer le spectre
subplot(4,1,2);
Y = fftshift(abs((1/N)*fft(ypitchb))) ;
plot(f-Fs/2,Y)
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre');

% Tracer le spectrogramme
subplot(4,1,3);
spectrogram(ypitchb, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogramme');

% Ecoute
%-------
soundsc(ypitchb,Fs);
pause(7)

%-----------------------------------------------------------------


%%
%----------------------------
% 3- ROBOTISATION DE LA VOIX
%-----------------------------
% Choix de la fréquence porteuse (2000, 1000, 500, 200)
Fc = 500;   %peut être modifié

yrob = Rob(y,Fc,Fs);

% Courbes
%-------------
% Initialisation :
% on change le nombre de points +ce que ça implique :
N = length(yrob);
t = [0:N-1]/Fs;
f = [0:N-1]*Fs/N;

figure('Name', 'Robotisation'); % 'Name' spécifie le nom de la figure;
subplot(4,1,1);
plot(t, yrob);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Évolution au cours du temps');

% Tracer le spectre
subplot(4,1,2);
Y = fftshift(abs((1/N)*fft(yrob))) ;
plot(f-Fs/2,Y)
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
title('Spectre');

% Tracer le spectrogramme
subplot(4,1,3);
spectrogram(yrob, window, overlap, nfft, Fs, 'yaxis');
title('Spectrogramme');




% Ecoute
%-------
soundsc(yrob,Fs);


