function y = PVoc(x, rapp, Nfft, Nwind)
% y = PVoc(x, rapp, Nfft , Nwind)
% Fonction du vocodeur de phase permettant de modifier un son audio 
% en interpolant dans le domaine fr�quentiel en passant 
% par la TF � court terme.
%
% x: signal audio d'origine (on traite 1 seule voie � la fois --> x est un
% vecteur)
%
% rapp : est le rapport entre la vitesse d'origine et la vitesse d'arriv�e
%
% Nfft : nombre de points (�chantillons) sur lesquels on r�alise la TF
% fen�tr�e
%
% Nwind : longueur, en nombre d'�chantillons, de la fen�tre de pond�ration lors de la TFCT



% Valeurs par d�faut dans le cas o� les param�tres d'entr�e ne sont pas tous donn�s
%----------------------------------------------------------------------------------
if nargin < 3
  Nfft = 1024;
end

if nargin < 4
  Nwind = Nfft;
end

% Param�tres utiles pour la TFCT
%--------------------------------
% On choisit une fen�tre de pond�ration de Hanning
% Afin d'avoir une bonne reconstruction avec une fen�tre de Hanning (signaux liss�s), 
% nous prenons un recouvrement de 25% de la fen�tre 
Nov = Nfft/4;
% Facteur d'�chelle 
%Remarque : pour retrouver la bonne amplitude lorsqu'on fait une 
% TFCT directe + une TFCT inverse, on le prend �gal � 2/3... 
% nous ne d�taillerons pas ici la d�monstration. 
% Dans notre application, on peut le prendre = 1 
scf = 1.0;

% 1- CALCUL DE LA TFCT
%-----------------------
X = scf * TFCT(x', Nfft, Nwind, Nov);

% 2- Interpolation des �chantillons fr�quentiels
%------------------------------------------------
% Calcul de la nouvelle base de temps (en terme d'�chantillons)
% cela correspond au nouveau nombre de trames (fen�tres temporelles)
[nl, nc] = size(X);
Nt = [0:rapp:(nc-2)];
% Remarque :
% on prend Ntmax � (nc-2) au lieu de (nc-1) car lors de l'interpolation,
% on travaille avec les colonnes n et n+1, n appartenent � Nt.

% Calcul de la nouvelle TFCT
X2 = TFCT_Interp(X, Nt, Nov);
% Remarque : vous devrez cr�er cette fonction "TFCT_Interp" !


% 3- CALCUL DE LA TFCT INVERSE
%------------------------------
y = TFCTInv(X2, Nfft, Nwind, Nov)';


