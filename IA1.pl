%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialisation et lancement du jeu %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tableau initial
initialiser([
		   ['_','_','_','_','_','_'],
	       ['_','_','_','O','O','O'],  
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'],
	       ['_','_','_','_','_','_'] 
]).



% Dans la grille du dessus, chaque ligne correspond à une colonne du jeu de puissance4.
% la casse de coordonnée (1;1) dans la grille ci-dessus correspond à la case "tout en haut à droite" du jeu de puissance4
% La casse de coordonnée (6;7) dans la grille ci-dessus correspond à la case "tout en bas  à gauche" du jeu de puissance4

puissance4 :- initialiser(G), afficher(G), nl, jouerCoup('X', G).


%%%%%%%%%%%%%%%%%%%%%%%
%% Mécaniques du jeu %%
%%%%%%%%%%%%%%%%%%%%%%%
joueurSuivant('X','O').
joueurSuivant('O','X').

remplie(G):- append(G,X), \+ member('_', X).

gameOver(Joueur,G):- victoire(Joueur,G), write('Victoire du joueur '), write(Joueur), !.
gameOver(_,G):- remplie(G), write('Match nul, la grille est pleine!'), !.

jouerCoup(Joueur,G):- joueurSuivant(Joueur, JoueurSuivant), gameOver(JoueurSuivant,G).
jouerCoup('X',G):-
			write('Au tour de X de jouer.'),
            lireColonne(C), % entrée utilisateur
            ajouterDansColonne('X', C, G, G2),
			afficher(G2), nl, %afficher la grille de jeu
            jouerCoup('O', G2). %faire jouer le joueur suivant
jouerCoup('O',G):- 
			write('Au tour de O de jouer.'), nl,
			%repeat,
            %random(1,8,C),
			ia1('O', G, G2, 7),
            %ajouterDansColonne('O', C, G, G2),
			afficher(G2), nl, %afficher la grille de jeu
            jouerCoup('X', G2). %faire jouer le joueur suivant


%%%%%%%%%%%%%%%%%%%%%%%%
%% Afficher la grille %%
%%%%%%%%%%%%%%%%%%%%%%%%
afficher(G):- afficherLignes(G,6), !.

afficherLignes(_,0).
afficherLignes(G,N):- afficherLigne(G,G2), nl, N2 is N-1, afficherLignes(G2,N2).

% Permet dafficher les premiers éléments de chaque colonne.
% X est le premier élément de la première colonne
% Y est le restant de la première colonne
% Z représente les autres colonnes 
% Z2 est le restant des colonnes (toutes sauf la première) privées de leur premier élément
afficherLigne([],_).
afficherLigne([[X|Y]|Z],[Y|Z2]):- write(X), write(' '), afficherLigne(Z,Z2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ajouter un coup (jeton) dans une colonne précise %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fonction pour ajouter dans une colonne précise
ajouterDansColonne(X,1,[Y|Z],[Y2|Z]):- ajouterAuDessus(X,Y,Y2),!.
ajouterDansColonne(X,N,[Y|Z],[Y|T]):- N2 is N-1, ajouterDansColonne(X,N2,Z,T).

% Fonction pour ajouter au dessus du dernier pion
ajouterAuDessus(X,['_'],[X]):- !. % si la colonne est vide, on ajoute à la fin
ajouterAuDessus(X,['_',H|Q],[X,H|Q]):- H \== ('_'), !. % si l'on souhaite jouer au dessus de quelqu'un
ajouterAuDessus(X,['_'|Q],['_'|Q2]):- ajouterAuDessus(X,Q,Q2). % utilisé pour descendre dans la colonne

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Vérification partie finie (gagnant) %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calcul de quand le joueur peut gagner
%4 cas pour gagner
%CAS N°1 = Le joueur X gagne car il a passé 4 pions à la verticale
victoire(X,G):- append(_, [H|_], G), append(_,[X,X,X,X|_],H),!.
%CAS N°2 = Le joueur X gagne car il a passé 4 pions à l'horizontal
victoire(X,G):- append(_,[C1,C2,C3,C4|_],G), %4 colonnes adjacentes
           append(I1,[X|_],C1),
           append(I2,[X|_],C2),
		   append(I3,[X|_],C3),
		   append(I4,[X|_],C4),
		   length(I1,L1), length(I2,L2), length(I3,L3), length(I4,L4),
           L1 is L2, L1 is L3, L1 is L4.
%CAS N°3 = Le joueur X gagne car il a crée une diagonale de gauche (haut) à droite (bas)
victoire(X,G):- append(_,[C1,C2,C3,C4|_],G), %4 colonnes adjacentes
		   append(I1,[X|_],C1),
		   append(I2,[X|_],C2),
		   append(I3,[X|_],C3),
		   append(I4,[X|_],C4),
		   length(I1,L1), length(I2,L2), length(I3,L3), length(I4,L4),
		   L2 is L1-1, L3 is L2-1, L4 is L3-1. 
%CAS N°4 = Le joueur X gagne car il a créé une diagonale de gauche (bas) à droite (haut)
victoire(X,G):- append(_,[C1,C2,C3,C4|_],G), %4 colonnes adjacentes
		   append(I1,[X|_],C1),
           append(I2,[X|_],C2),
		   append(I3,[X|_],C3),
		   append(I4,[X|_],C4),
		   length(I1,L1), length(I2,L2), length(I3,L3), length(I4,L4),
		   L2 is L1+1, L3 is L2+1, L4 is L3+1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lecture de la colonne utilisateur %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%colonnes valides
col(1).
col(2).
col(3).
col(4).
col(5).
col(6).
col(7).

lireColonne(C):- nl, write('Colonne : '), repeat,
		get_char(L),
        atom_number(L,C),
        col(C).

%%%%%%%%%
%% IA1 %%
%%%%%%%%%
%vérifie si l'adversaire peut gagner au coup suivant
nePerdPasAuProchainCoup(_, _, 0):-!.
nePerdPasAuProchainCoup(S, G, C):-joueurSuivant(S,S2), 
						((ajouterDansColonne(S2, C, G, G2)) ->
						(\+ victoire(S2,G2),
						C2 is C-1, 
						nePerdPasAuProchainCoup(S, G, C2));
						(C2 is C-1, 
						nePerdPasAuProchainCoup(S, G, C2))).
						
%vérifie si l'IA peut gagner à ce coup
neGagnePasEnUnCoup(_, _, 0):-fail.
neGagnePasEnUnCoup(S, G, C, C2):-  ((ajouterDansColonne(S, C, G, G2)) ->
						((victoire(S,G2)->!;
						C2 is C-1, 
						neGagnePasEnUnCoup(S, G, C2, C2));
						(C2 is C-1, 
						neGagnePasEnUnCoup(S, G, C2, C2))).
						
%implémentation de l'IA1 (si possible cherche à jouer au milieu de la grille)
ia1(S, G, G2, C):- neGagnePasEnUnCoup(S, G, 7, C), ajouterDansColonne(S, C, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 4, G, G2), nePerdPasAuProchainCoup(S, G2,7).
ia1(S, G, G2, _):-ajouterDansColonne(S, 5, G, G2), nePerdPasAuProchainCoup(S, G2,7).
ia1(S, G, G2, _):-ajouterDansColonne(S, 3, G, G2), nePerdPasAuProchainCoup(S, G2,7).
ia1(S, G, G2, _):-ajouterDansColonne(S, 6, G, G2), nePerdPasAuProchainCoup(S, G2,7).
ia1(S, G, G2, _):-ajouterDansColonne(S, 2, G, G2), nePerdPasAuProchainCoup(S, G2,7).
ia1(S, G, G2, _):-ajouterDansColonne(S, 7, G, G2), nePerdPasAuProchainCoup(S, G2,7).
ia1(S, G, G2, _):-ajouterDansColonne(S, 1, G, G2), nePerdPasAuProchainCoup(S, G2,7).

%si l'ia perd dans tous les cas
ia1(S, G, G2, _):-ajouterDansColonne(S, 4, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 5, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 3, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 6, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 2, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 7, G, G2).
ia1(S, G, G2, _):-ajouterDansColonne(S, 1, G, G2).
