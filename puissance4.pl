
% Tableau initial
initialiser(grille([
		   ['_','_','_','_','_','_'],   
	       ['_','_','_','_','_','_'],  
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'] 
])).


% Dans la grille du dessus, chaque ligne correspond à une colonne du jeu de puissance4.
% la casse de coordonnée (1;1) dans la grille ci-dessus correspond à la case "tout en haut à droite" du jeu de puissance4
% La casse de coordonnée (6;7) dans la grille ci-dessus correspond à la case "tout en bas  à gauche" du jeu de puissance4

puissance4 :- initialiser(X), afficher(X), jouerCoup('X',X).


% Afficher la grille
afficher(grille(G)):- afficherLignes(G,6).

afficherLignes(_,0).
afficherLignes(G,N):- afficherLigne(G,G2), nl, N2 is N-1, afficherLignes(G2,N2).

% Permet dafficher les premiers éléments de chaque colonne.
% X est le premier élément de la première colonne
% Y est le restant de la première colonne
% Z représente les autres colonnes 
% Z2 est le restant des colonnes (toutes sauf la première) privées de leur premier élément
afficherLigne([],_).
afficherLigne([[X|Y]|Z],[Y|Z2]):- write(X), write(' '), afficherLigne(Z,Z2).



% Fonction pour ajouter au dessus du dernier pion
ajouterAuDessus(X,['_'],[X]). % si la colonne est vide, on ajoute à la fin
ajouterAuDessus(X,['_',H|Q],[X,H|Q]):- H \== ('_'), !. % si l'on souhaite jouer au dessus de quelqu'un
ajouterAuDessus(X,['_'|Q],['_'|Q2]):- ajouterAuDessus(X,Q,Q2). % utilisé pour descendre dans la colonne


%%Jouer coups
joueurSuivant('X','O').
joueurSuivant('O','X').


%Pour pouvoir jouer un coup, il faut que la grille ne soit pas remplie
remplie(G):- append(G,X), \+ member('_', X).


%%cas où le jeu s'arrête 
gameOver(grille(G)) :- victoire(X,G),write('Victoire du joueur '), write(X),!. 
gameOver(grille(G)) :- remplie(G), write('Match nul, la grille est pleine!'),!.





%Calcul de quand le joueur peut gagner
%4 cas pour gagner
%CAS N°1 = Le joueur X gagne car il a passé 4 pions à la verticale
victoire(X,grille(G)):- append(_, [H|_], G), append(_,[X,X,X,X|_],H). 
%CAS N°2 = Le joueur X gagne car il a passé 4 pions à l'horizontal
victoire(X,grille(G)):- append(_,[C1,C2,C3,C4|_],G), %4 colonnes adjacentes
           append(I1,[X|_],C1),
           append(I2,[X|_],C2),
		   append(I3,[X|_],C3),
		   append(I4,[X|_],C4),
		   length(I1,L1), length(I2,L2), length(I3,L3), length(I4,L4),
           L1 is L2, L1 is L3, L1 is L4.
%CAS N°3 = Le joueur X gagne car il a crée une diagonale de gauche (haut) à droite (bas)
victoire(X,grille(G)):- append(_,[C1,C2,C3,C4|_],G), %4 colonnes adjacentes
		   append(I1,[X|_],C1),
		   append(I2,[X|_],C2),
		   append(I3,[X|_],C3),
		   append(I4,[X|_],C4),
		   length(I1,L1), length(I2,L2), length(I3,L3), length(I4,L4),
		   L2 is L1-1, L3 is L2-1, L4 is L3-1. 
%CAS N°4 = Le joueur X gagne car il a créé une diagonale de gauche (bas) à droite (haut)
victoire(X,grille(G)):- append(_,[C1,C2,C3,C4|_],G), %4 colonnes adjacentes
		   append(I1,[X|_],C1),
           append(I2,[X|_],C2),
		   append(I3,[X|_],C3),
		   append(I4,[X|_],C4),
		   length(I1,L1), length(I2,L2), length(I3,L3), length(I4,L4),
		   L2 is L1+1, L3 is L2+1, L4 is L3+1.



