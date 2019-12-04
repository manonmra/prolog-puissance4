%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialisation et lancement du jeu %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tableau initial
initialiser([
		   ['_','_','_','_','_','X'],
	       ['_','_','_','O','O','O'],  
	       ['_','_','_','O','O','X'],
	       ['_','_','_','O','O','X'],
	       ['_','_','_','_','_','X'],
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
neGagnePasEnUnCoup(_, _, 0):-!.
neGagnePasEnUnCoup(S, G, C, C2):-  ((ajouterDansColonne(S, C, G, G2)) ->
						(\+ victoire(S,G2),
						C2 is C-1,
						neGagnePasEnUnCoup(S, G, C2, C2));
						(C2 is C-1, 
						neGagnePasEnUnCoup(S, G, C2, C2))).
						
%implémentation de l'IA1 (si possible cherche à jouer au milieu de la grille)
ia1(S, G, G2, C):- \+ neGagnePasEnUnCoup(S, G, 7, C), ajouterDansColonne(S, C, G, G2).
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

%%%%%%%%%%%%%
%% MIN MAX %%
%%%%%%%%%%%%%

adversaire('O','X'). 
adversaire('X','O').

% choisir le MeilleurCoup parmi l'ensemble des Coups à partir de la grille courante
% en utilisant minmax, anticipant de Profondeur niveaux. MaxMin indique si l'on minimise ou maximise couramment. 
% Record enregistre le meilleur mouvement courant. 
evaluerEtChoisir([Coup|Coups], Grille, Profondeur, MaxMin, Record, MeilleurCoup, Joueur):- 
	ajouterDansColonne(Joueur, Coup, Grille, Grille1),
	minmax(Profondeur, Grille1, MaxMin, Coup, Valeur, Joueur), 
	maj(Coup, Valeur, Record, Record1), 
	adversaire(Joueur, ProchainJoueur), 
	evaluerEtChoisir(Coups, Grille, Profondeur, MaxMin, Record1, MeilleurCoup, ProchainJoueur). 
evaluerEtChoisir([], Grille, Profondeur, MaxMin, Record, MeilleurCoup, Joueur). 

minmax(0, Grille, MaxMin, Coup, Valeur, Joueur):-
	valeur(Grille, Coup, V, Joueur),
	Valeur is V*MaxMin. 
minmax(Profondeur, Grille, MaxMin, Coup, Valeur, Joueur):-
	Profondeur>0,
	%set_of(M, bouger(Grille, M), Coups), % fonction qui renvoie une grille après un coup
	ajouterDansColonne(Joueur, Coup, Grille, Grille1),
	coupsPossibles(Grille1, Coups),
	Profondeur1 is Profondeur-1,
	MinMax is -MaxMin,
	adversaire(Joueur,AutreJoueur),
	evaluerEtChoisir(Coups, Grille, Profondeur1, MinMax, (0,-1000),(Coup, Valeur), AutreJoueur). 

coupsPossibles(Grille1, [1,2,3,4,5,6,7]).

maj(Coup, Valeur, (Coup1, Valeur1), (Coup1, Valeur1)):-
	Valeur=<Valeur1. 
maj(Coup, Valeur, (Coup1,Valeur1),(Coup,Valeur)):-
	Valeur>Valeur1. 

%permet d'évaluer une position(grille)
valeur(Grille, Coup, V, Joueur):-
	pointsDePosition(Grille, Coup, Points1, Joueur),
	V is Points1.
	%nl,  write('POINTS : '), write(V).

creerUneListeTest([1,2,3,4,5,6,7]).
testPointsDePosition(X) :- initialiser(Grille), creerUneListeTest(Liste),evaluerEtChoisir(Liste, Grille, 2, 1, Record, MeilleurCoup, 'O'), nl,write('Meilleur coup : '),write(MeilleurCoup).

pointsDePosition(Grille, Coup, Point, Joueur):-
	%regarder si on aligne notre nouveau pion avec d'autres pions
	%regardons vers le bas
	recupererLaColonneN(Coup, Grille, Col),
	recupererLesJetonsEnDessous(Col, 0, Joueur, NombreDeJetons),
	(NombreDeJetons>1->
		NombreDeJetonsPow is NombreDeJetons-1,
		pow(10,NombreDeJetonsPow, PointPositionBas);
		PointPositionBas is 0),
	%nl,write('point position bas : '), write(PointPositionBas),

	recupererNumeroLigne(Col, 1, NumeroLigne),
	%Regardons vers la gauche 
	recupererLesJetonsAGauche(Coup,NumeroLigne,Grille, 0,NombreDeJetonsAGauche, Joueur),
	(NombreDeJetonsAGauche>0->pow(10,NombreDeJetonsAGauche, PointPositionGauche);PointPositionGauche is 0),
	%nl,write('point position gauche : '), write(PointPositionGauche),

	%Regardons vers la droite 
	recupererLesJetonsADroite(Coup,NumeroLigne,Grille, 0,NombreDeJetonsADroite, Joueur),
	(NombreDeJetonsADroite>0->pow(10,NombreDeJetonsADroite, PointPositionDroite);PointPositionDroite is 0),
	%nl,write('point position droite : '), write(PointPositionDroite),

	NombreDeJetonsHorizontal is (NombreDeJetonsAGauche+NombreDeJetonsADroite),
	(NombreDeJetonsHorizontal>0 -> pow(10,NombreDeJetonsHorizontal,NombreDePointsHorizontal); NombreDePointsHorizontal is 0),
	%nl,write('Nombre de points horizontal :'), write(NombreDePointsHorizontal),

	Point is PointPositionBas+NombreDePointsHorizontal.

recupererLaColonneN(1,[Y|Z],Y):- !.
recupererLaColonneN(N,[Y|Z],Col):- N2 is N-1, recupererLaColonneN(N2,Z,Col).

recupererNumeroLigne(['_'|Z], N, NumeroLigne) :- N2 is N+1,recupererNumeroLigne(Z,N2,NumeroLigne). 
recupererNumeroLigne([Y|Z], N, NumeroLigne) :- NumeroLigne is N, !.

recupererLesJetonsEnDessous([], N, Joueur, Result):- Result is N,!. 
recupererLesJetonsEnDessous(['_'], N, Joueur, Result):- Result is N,!. % la colonne était vide, on va renvoyer 0
recupererLesJetonsEnDessous(['_'|Q], N, Joueur, Result):- recupererLesJetonsEnDessous(Q,N, Joueur, Result). % utilisé pour descendre dans la colonne
recupererLesJetonsEnDessous([H|Q], N, Joueur, Result):- 
	H \== ('_'), 
	(H == Joueur-> 
	N2 is N+1,
	recupererLesJetonsEnDessous(Q, N2, Joueur, Result)% si l'on souhaite jouer au dessus de quelqu'un
	; Result is N).


%% fonction puissance
pow(_,0,1).
pow(B,E,R) :- E > 0,!, E1 is E -1, pow(B,E1,R1), R is B * R1.

recupererLesJetonsAGauche(1, NumeroLigne, Grille, N, NombreDeJetons, Joueur):-NombreDeJetons is N,!.% on sort parce qu'on sort du terrain
recupererLesJetonsAGauche(NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons, Joueur):-
	recupererJetonAGauche(NumeroColonne, NumeroLigne, Grille, JetonAGauche),
	lireJetonDeGauche(JetonAGauche, Joueur, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons).


% jeton, joueur
lireJetonDeGauche(X, X, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons) :- 
	NumColonneDeGauche is NumeroColonne-1,
	N2 is N+1,
	recupererLesJetonsAGauche(NumColonneDeGauche, NumeroLigne, Grille, N2, NombreDeJetons, X).
lireJetonDeGauche('_', X, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons) :-% on sort parce que c'est vide
	recupererLesJetonsAGauche(1, NumeroLigne, Grille, N, NombreDeJetons, X).
lireJetonDeGauche(X, Joueur, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons):-
	recupererLesJetonsAGauche(1, NumeroLigne, Grille, N, NombreDeJetons, Joueur). %on sort parce que c'est un jeton de l'autre joueur


recupererJetonAGauche(NumeroColonne, NumeroLigne, Grille, Jeton):-
	NumColonneDeGauche is NumeroColonne-1,
	recupererLaColonneN(NumColonneDeGauche,Grille, ColonneGauche),
	recupererJetonLigneN(ColonneGauche, NumeroLigne, Jeton).

%%%%%%%%%%%%%%%A DROITE 

recupererLesJetonsADroite(7, NumeroLigne, Grille, N, NombreDeJetons, Joueur):-NombreDeJetons is N,!.% on sort parce qu'on sort du terrain
recupererLesJetonsADroite(NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons, Joueur):-
	recupererJetonADroite(NumeroColonne, NumeroLigne, Grille, JetonADroite),
	lireJetonDeDroite(JetonADroite, Joueur, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons).


% jeton, joueur
lireJetonDeDroite(X, X, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons) :- 
	NumColonneDeDroite is NumeroColonne+1,
	N2 is N+1,
	recupererLesJetonsADroite(NumColonneDeDroite, NumeroLigne, Grille, N2, NombreDeJetons, X).
lireJetonDeDroite('_', X, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons) :-
	recupererLesJetonsAGauche(1, NumeroLigne, Grille, N, NombreDeJetons, X).
lireJetonDeDroite(X, Joueur, NumeroColonne, NumeroLigne, Grille, N, NombreDeJetons):-
	recupererLesJetonsADroite(7, NumeroLigne, Grille, N, NombreDeJetons, Joueur). %on sort parce que c'est un jeton de l'autre joueur


recupererJetonADroite(NumeroColonne, NumeroLigne, Grille, Jeton):-
	NumColonneDeDroite is NumeroColonne+1,
	recupererLaColonneN(NumColonneDeDroite,Grille, ColonneDroite),
	recupererJetonLigneN(ColonneDroite, NumeroLigne, Jeton).

%%%%%%%%%%%%%%%%%%


recupererJetonLigneN([X|Y], 1 , X) :- !.
recupererJetonLigneN([X|Y], NumeroLigne, Jeton):-NumeroLigne2 is NumeroLigne-1, recupererJetonLigneN(Y, NumeroLigne2, Jeton).