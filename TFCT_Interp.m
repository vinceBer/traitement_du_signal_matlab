%% Fonction TFCT_Interp
function y = TFCT_Interp(X,t,Nov) ; 
% X est la matrice après la TFCT 
% t est un vecteur utilisé pour l'interpolation 
% Nov est le nombre d’échantillons correspondant au chevauchement trames lors de la TFCT

% Vérification des dimensions des entrées
assert(isnumeric(X) && ismatrix(X), 'X doit être une matrice numérique.');
assert(isnumeric(t) && isvector(t), 't doit être un vecteur numérique.');
assert(isscalar(Nov) && Nov > 0, 'Nov doit être un nombre scalaire positif.');


% on récupère le nombre de lignes et colonnes de la matrice d'entrée X
[nl, ~] = size(X); 
% N est le nombre de pts dans la TFCT (transformée de fourier à court terme)
% est calculé comme le double du nombre de colonnes -1
N = 2 * (nl - 1);

%% Initialisations des variables
%-------------------
% y est initialisé à 0, est une matrice pour stocker les résultats interpolés
y = zeros(nl, length(t));

% phi est un vecteur qui stocke la 1ère phase de X (phase initiale)
phi = angle(X(:,1));

% Dphi0 représente les déphasages entre chaque échantillons de la TFCT
dphi0 = zeros(nl,1);
dphi0(2:nl) = (2*pi*Nov) ./ (N./(1:(N/2)));

% Ncy est l'indice de la colonne interpolée
Ncy = 1;

% on ajoute une colonne de zéros à X pour éviter les problèmes d'indices
% lors de l'interpolation
X = [X, zeros(nl, 1)];

%% Boucle utilisée pour faire l'interpolation
%----------------------------
%Pour chaque valeur de t, on calcule la nouvelle colonne de Y à partir de 2
%colonnes successives de X

% tn est une valeur de l'ensemble des indices fourni en entrée 
% a et b sont les coefficients d'interpolation linéaire (vus sur la fiche
% interpolation explication (en cours))
% Ncx1 et Ncx2 sont les indices des colonnes de X utilisées pour
% l'interpolaiton
% My est le module interpolé
% dphi est le nouvel argument calculé pour l'interpolation
% phi est mis à jour avec le nouvel argument
% la colonne interpolé est stockée dans la matrice y

for tn = t  
    b = tn - floor(tn); %calcul du coefficient b en fonction de n 
    a = 1 - b; %calcul du coefficient a par deduction de b
    Ncx1 = floor(tn) + 1;  %recuperation du premier indice de la matrice x
    Ncx2 = Ncx1 + 1; %recuperation du deuxieme indice de la matrice x
    My = a * X(:, Ncx1) + b * X(:, Ncx2); %calcul du module interpole 
    dphi = angle(X(:, Ncx2)) - angle(X(:, Ncx1)) - dphi0; %calcul du nouvel argument 
    dphi = mod(dphi + pi, 2*pi) - pi; % Utilisation de la fonction mod pour assurer que l'angle est entre -pi et pi (calcul du nouvel argument)
    phi = phi + dphi + dphi0; %calcul du nouvel argument
    y(:, Ncy) = My .* exp(1j * phi); % ajout de la valeur dans la matrice y
    Ncy = Ncy +1 ;
end   

