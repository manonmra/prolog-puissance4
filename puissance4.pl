
% Tableau initial
initialiser(grille([                    %  _______________________
		   ["_","_","_","_","_","_"],   % |(1:1)             (6;1)|
	       ["_","_","_","_","_","_"],   % |
	       ["_","_","_","_","_","_"],
	       ["_","_","_","_","_","_"],
	       ["_","_","_","_","_","_"],
	       ["_","_","_","_","_","_"],
	       ["_","_","_","_","_","_"]    % |                  (6;7)|
])).
% Dans la grille du dessus, chaque ligne correspond à une collone du jeu de puissance4.
% la casse de coordonnée (1;1) dans la grille ci-dessus correspond à la case "tout en haut à droite" du jeu de puissance4
% La casse de coordonnée (6;7) dans la grille ci-dessus correspond à la case "tout en bas  à gauche" du jeu de puissance4



puissance4 :- initialiser(X), afficher(X), jouerCoup('X',X).



% Fonction pour ajouter au dessus du dernier pion
ajouterAuDessus(X,['_'],[X]):- !. % si la colonne est vide, on ajoute à la fin
ajouterAuDessus(X,['_',H|Q],[X,H|Q]):- H \== ('_'), !. % si l'on souhaite jouer au dessus de quelqu'un
ajouterAuDessus(X,['_'|Q],['_'|Q2]):- ajouterAuDessus(X,Q,Q2). % utilisé pour descendre dans la colonne


% Afficher la grille
afficher(grille(G)):- afficherLignes(G,6).

afficherLignes(G,0):- !.
afficherLignes(G,N):- afficherLigne(G,N,1), nl, afficherLignes(G,N-1).

afficherLigne(G,8):- !.
afficherLigne(G,Nl,Nc):- afficherColonne(G,Nl,Nc), write(" "), afficherLigne(G,Nl,Nc+1).

afficherColonne(G,Nl,Nc):- write().


%%Jouer coups
joueurSuivant('X','O');
joueurSuivant('O','X');
        %%cas où le jeu s'arrête 
gameOver(grille(G)) :- victoire(X,G),write('Victoire du joueur '), write(X),!. 
gameOver(grille(G)) :- plein(G), write('Match nul, la grille est pleine!'),!.

jouerCoup(_,grille(G)):- gameOver(G).
jouerCoup(Joueur,G) :- write('Au tour de '), write(Joueur), write(' de jouer.'),
            %%%%%jeu
            %entrée de la colonne
            %que se passe-t-il si colonne pleine? 
            joueurSuivant(Joueur, JoueurSuivant), %changer de joueur
            jouerCoup(JoueurSuivant). %faire jouer le joueur suivant


%Pour pouvoir jouer un coup, il faut que la grille ne soit pas pleine
remplie(grille(G)):- append(_,[C1,C2,C3,C4,C5,C6,C7|_],G),
		   append(I1,[X|_],C1), I1\=='_',
           append(I2,[X|_],C2), I2\=='_',
		   append(I3,[X|_],C3), I3\=='_',
		   append(I4,[X|_],C4), I4\=='_',
		   append(I5,[X|_],C5), I5\=='_',
           append(I6,[X|_],C6), I6\=='_',
		   append(I7,[X|_],C7), I7\=='_',
		   length(I1,L1),length(I2,L2),length(I3,L3),length(I4,L4),length(I5,L5),length(I6,L6),length(I7,L7),
		   L1 >= 6, L2 >= 6, L3 >= 6, L4 >= 6, L5 >= 6, L6 >= 6, L7 >= 6.

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



