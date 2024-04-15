%% Fonction robotisation
function rob= Rob(y,Fc,Fs)
%% on va aboir besoin de :
% y est le signal qu'on va modifier
% Fc est la fréquence à laquelle on va robotiser  la voix
% Fs est la fréquence qu'on va utiliser pour échantilloner le signal

% % déclaration du vecteur temporel
t = [0:length(y)-1]/Fs;

% on transpose ce vecteur pour l'avoir dans le "bon" sens pour le calcul suivant
p=transpose(t);

% on module le signal avec une exponentille temporelle complexe
yrob= y.*exp(-j*2*pi*Fc*p);

% pour robotiser notre voix on aura besoin uniquement de la partie reel
rob=real(yrob);