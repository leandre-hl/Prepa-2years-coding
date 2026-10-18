[🇫🇷 Français](README.fr.md) | [🇬🇧 English](README.md)

# Code en prépa — MP2I / MPI (2024–2026)

Ce dépôt rassemble le code que j'ai écrit pendant mes deux années de classes préparatoires aux grandes écoles (CPGE) : **MP2I** en première année et **MPI** en seconde. Il contient surtout les exercices, les TP et les devoirs maison que j'ai réalisés en **OCaml**, en **C** et en **SQL**, des premières fonctions récursives jusqu'aux threads, aux automates et aux solveurs SAT.

Ce n'est pas un produit abouti : c'est la trace de deux années passées à apprendre l'algorithmique et les structures de données en les implémentant.

---

## Contexte

J'ai suivi la filière MP2I → MPI.

| Année | Filière | Signification | Contenu du cours d'informatique |
|-------|---------|---------------|---------------------------------|
| 1re année | **MP2I** | *Mathématiques, Physique, Ingénierie et Informatique* | Programmation (OCaml, C), récursivité, structures de données, arbres, graphes, retour sur trace, programmation dynamique, compression de base et SQL |
| 2e année | **MPI** | *Mathématiques, Physique, Informatique* | Algorithmique et théorie : algorithmes de graphes, automates et expressions régulières, grammaires formelles, logique et SAT, stratégies de jeux, concurrence, bases de données |

**Vocabulaire utilisé dans ce dépôt**

- **TD** (*travaux dirigés*) : exercices traités en classe.
- **TP** (*travaux pratiques*) : séances sur ordinateur.
- **DM** (*devoir maison*) : devoir à faire chez soi, noté.
- **TP noté** : épreuve pratique sur machine, chronométrée et notée.

Plusieurs sujets étaient accompagnés d'un code de départ, de fichiers de données ou d'un énoncé PDF fournis par mes professeurs. Les solutions sont les miennes.

---

## Organisation du dépôt

```
prepa-coding/
├── 1st-year-MP2I/
│   ├── TD/                    # exercices de TD (OCaml et C)
│   ├── TP/                    # séances de TP (tp7 … tp22, tp_note2)
│   ├── DM/Puzzle-color/       # devoir maison (avec son propre README)
│   └── algo_cours_implementation/
└── 2nd-year-MPI/
    ├── TP/                    # TP1 … TP18
    └── DM3/                   # devoir maison sur les arbres couvrants minimaux
```

**Langages :** OCaml (programmation fonctionnelle, arbres, graphes, logique), C (gestion de la mémoire, pointeurs, performance, threads), SQL (requêtes sur des bases de données relationnelles).

---

# Première année — MP2I (nov. 2024 – juin 2025)

La première année mêle des **TD**, des **TP** et un **DM**. Les travaux sont regroupés par thème ; les dates sont approximatives.

## 1. Programmation fonctionnelle et récursivité (OCaml)

- **TD5 — premiers exercices de récursivité** (`TD/td5_ocaml`, nov. 2024). La fonction de Tak, les nombres tétraédriques, la factorielle sans multiplication, la recherche de racine par dichotomie, les quaternions, la géométrie dans l'espace et une fractale récursive dessinée en ASCII.
- **TP7 — suites** (`TP/tp7_ocaml_suites`, nov. 2024). Suites représentées par une valeur initiale et une fonction ; suite de Syracuse et détection de cycle avec l'algorithme du lièvre et de la tortue de Floyd.
- **TP8 — ensembles d'entiers naturels** (`TP/tp8_ocaml_entiers-naturels`, déc. 2024). Trois représentations (listes, ensembles finis ou cofinis, prédicats) avec union, intersection, complémentaire et inclusion.
- **TD6 — listes** (`TD/td6_ocaml`, déc. 2024 – janv. 2025). Exercices marquants : codage par plages (RLE), suite de Conway, polynômes sous forme de listes de monômes, rationnels et entiers de Gauss sous forme d'enregistrements, entrelacements et mélanges, sous-séquences, un jeu de retournement de préfixes (algorithme de Chvátal) et la courbe du dragon.

## 2. Structures de données

- **TD10 — piles** (`TD/td10_ocaml`, fév. 2025). Vérification du parenthésage, rotations et retournements de piles.
- **TD11 — arbres binaires** (`TD/td11_ocaml`, mars – avr. 2025). Exercices marquants : numérotation de type tas et de Sosa–Stradonitz, profondeur, symétrie, élagage, recherche de sous-arbre, fusion, nombre de Strahler, puissances de Knuth, arbre de Stern–Brocot, évaluateur d'expressions mathématiques symboliques et un problème de concours sur les arbres croissants.
- **Tas binaires** (`TD/tas_binaires`, mars 2025). Conversion entre tableau et arbre, vérification de la validité d'un tas.
- **TP14 — ADN et tries** (`TP/tp14_ocaml_adn-et-tries`, mars 2025). Un trie à quatre branches (A, C, G, T) : appartenance, insertion, suppression, conversion en listes, tri à l'aide du trie.
- **TP15 — arbres rouge-noir** (`TP/tp15_c_arbres-rouges-noirs`, mars 2025). En C : pointeurs vers le parent, liens de parenté (oncle, grand-parent), vérification des invariants, rotations et insertion avec rééquilibrage.
- **Arbres k-d** (`TD/kd_trees`, juin 2025). Un arbre k-d en dimension 2 avec un test d'appartenance.

## 3. Retour sur trace, couverture exacte et puzzles

- **TP16 — N reines** (`TP/tp16_ocaml_backtracking-sur-echiquiers`, avr. 2025). Retour sur trace sur un échiquier.
- **TP17 — nonogrammes** (`TP/tp17_ocaml_nonogrammes`, avr. 2025). Un solveur de jeux de logique en images : énumération des arrangements valides de chaque ligne et colonne d'après ses indices, testé sur neuf grilles.
- **Solveur de sudoku** (`TD/td12_ocaml`, avr. 2025). Retour sur trace en profondeur sur les chiffres candidats.
- **DM — Puzzle coloré** (`DM/Puzzle-color`, avr. 2025). Puzzles à bords coloriés : des pièces carrées dont les côtés sont colorés doivent être pivotées et disposées dans un rectangle. Solveur par retour sur trace en OCaml, testé de 2×2 à 7×7. Il possède son propre README et son historique git.
- **TP18 — liens dansants** (`TP/tp18_c_liens-danssants`, mai 2025). L'algorithme X de Knuth avec les liens dansants, en C, pour les problèmes de couverture exacte ; appliqué aux N reines et au sudoku (un petit générateur transforme une grille en instance de couverture exacte).

## 4. Programmation dynamique et algorithmes gloutons

- **TD12 — retour sur trace et programmation dynamique en C** (`TD/td12_c`, mai 2025). Théorème des McNuggets, plus longue sous-suite croissante, chemins auto-évitants, tableaux autoréférents, règles de Golomb, chemin optimal dans une grille, découpe de ruban, partitions en palindromes.
- **TD13 — algorithmes gloutons** (`TD/td13_ocaml`, mai 2025). Placer le moins de stations possible le long d'une route pour que chaque maison soit couverte.
- **Floyd–Warshall** (`algo_cours_implementation/floyd-warshall.ml`, août 2025). Plus courts chemins entre toutes les paires de sommets.

## 5. Graphes et applications

- **TD14 — théorie des graphes** (`TD/td14_ocaml`, mai – juin 2025). Inversion et symétrisation de graphes orientés, puits, cycles courts, circuits eulériens, partition en composantes connexes.
- **TP19 — labyrinthes** (`TP/tp19_ocaml_labyrinthes`, juin 2025). Génération de labyrinthes comme arbres couvrants (DFS aléatoire et Kruskal aléatoire), vérification des labyrinthes « parfaits », recherche de chemin, affichage avec Graphics et en ASCII.
- **TP20 — trajets en bus** (`TP/tp20_c_trajets-en-bus`, juin 2025). Sur de vrais horaires : prochains départs, arrêts atteignables, puis Dijkstra et A* avec une file de priorité à base de tas binaire.
- **Réseaux de Petri** (`TD/petri`, juin 2025). Recherche des transitions franchissables et tir des transitions.
- **TP noté 2** (`TP/tp_note2`, juin 2025). Épreuve chronométrée sur des graphes aléatoires : génération pseudo-aléatoire des arêtes, union-find, statistiques sur les composantes, un problème de dénombrement.

## 6. Compression, aléatoire, géométrie et chaînes de caractères

- **TP10 — générateurs pseudo-aléatoires** (`TP/tp10_c_pseudo-aleatoire`, janv. 2025). LCG de Knuth, RANDU, MINSTD, une variante du Mersenne Twister, comparés par des nuages de points 2D/3D (images PPM) et par les tests OPSO, du parking et du rang de matrice.
- **TP11 — compression façon Bzip** (`TP/tp11_ocaml_compression_bzip`, janv. 2025). Transformée de Burrows–Wheeler, analyse des fréquences et des répétitions pour estimer la taille compressée.
- **TP12 — enveloppes convexes** (`TP/tp12_c_enveloppes`, fév. 2025). Marche de Jarvis et parcours de Graham en C, avec une pile et un tri écrits à la main.
- **TP22 — codage de Huffman** (`TP/tp22_c_compression-hufmann`, juin 2025). Fréquences, construction de l'arbre, dictionnaire de codes, écriture de fichiers bit à bit, sérialisation de l'arbre, décodage, taux de compression sur du texte et de l'ADN.
- **Chiffrement de chaînes** (`TD/chaines`, juin 2025). Un chiffrement de type Vigenère en C, avec un `strlen` écrit à la main.

## 7. Bases du C, tris et SQL

- **TD7 — tableaux en C** (`TD/td7_c`, janv. 2025). Plus long plateau, test de symétrie, retournement en place, sommes cumulées et différences.
- **Systèmes monétaires** (`TD/systeme_monaitaire`, janv. 2025). Rendu de monnaie, avec des structures et des tableaux dynamiques.
- **Algorithmes de tri** (`algo_cours_implementation/tris.c`, repris en mars 2026). Tris à bulles (simple et optimisé), par insertion, par sélection, rapide, fusion et par tas.
- **TP21 — SQL** (`TP/tp21_sql`, juin 2025). Requêtes sur une base de location de films : `LIKE`, agrégats, `GROUP BY`, `ORDER BY`, jointures.

---

# Seconde année — MPI (sept. 2025 – mai 2026)

La seconde année **n'a pas de dossier de TD** : elle se compose de TP et d'un devoir maison (DM3), regroupés ici par thème.

## 1. Remises à niveau

- **TP1 — OCaml** (`TP/TP1`, sept. 2025). Réécriture des fonctions sur les listes (`length`, `map`, `fold`, `partition`…), Fibonacci, arbres binaires et généraux avec génération aléatoire, parcours et affichage en texte.
- **TP2 — C** (`TP/TP2`, sept. 2025). PGCD, crible d'Ératosthène, tri par sélection, recherche dichotomique, listes chaînées, files, comptage des inversions (naïf et diviser pour régner), tableaux dynamiques redimensionnables.

## 2. Algorithmes de graphes

- **TP3 — graphes** (`TP/TP3`, sept. 2025). En OCaml : composantes connexes, détection de cycles, numérotation DFS, ordre topologique, composantes fortement connexes par l'algorithme de Kosaraju (réutilisé pour 2-SAT, voir plus bas).
- **DM3 — arbres couvrants minimaux** (`DM3`, sept. – oct. 2025). Deux langages : **Kruskal** en OCaml (union-find par rang, tri rapide écrit à la main) et **Borůvka** en C, testés par des assertions sur des graphes pondérés de 10 à 50 000 sommets.
- **TP4 — couplages dans un graphe biparti** (`TP/TP4`, oct. 2025). En C : chemins augmentants, couplage maximum, Hopcroft–Karp.

## 3. Automates, langages et logique

- **TP5 — automates finis** (`TP/TP5`, oct. 2025). En C : AFD et AFND, reconnaissance de mots, déterminisation par construction des parties (y compris une version qui ne construit que les états accessibles).
- **TP6 — expressions régulières** (`TP/TP6`, nov. 2025). En OCaml : analyseur syntaxique, simplification, linéarisation, langages des préfixes, suffixes et facteurs, automate de Glushkov.
- **TP11 — grammaires formelles** (`TP/TP11`, janv. 2026). En C : grammaires hors contexte, vérification de la forme normale de Chomsky, analyse CYK.
- **SAT dans TP3 et TP9** (`TP/TP3`, `TP/TP9`, sept. et déc. 2025). SAT par force brute et 2-SAT via le graphe d'implications ; puis MAX-SAT avec des formules CNF aléatoires issues d'une suite pseudo-aléatoire, retour sur trace exact, simulation d'affectations aléatoires et méthode des probabilités conditionnelles.
- **TP14 — logique propositionnelle** (`TP/TP14`, fév. 2026). Évaluation de formules, test de tautologie, recherche de preuve par le calcul des séquents.

## 4. Jeux et stratégies

- **TP7 — morpion généralisé** (`TP/TP7`, nov. 2025). En C : *k* pions alignés sur un plateau *n*×*n*, encodage des états, stratégie optimale par attracteurs avec un dictionnaire de mémoïsation.
- **TP8 — Puissance 4** (`TP/TP8`, nov. 2025). En OCaml : affichage coloré dans le terminal, stratégie aléatoire, comparaison de stratégies, recherche à profondeur limitée avec heuristique.

## 5. Concurrence

- **TP15 — threads et exclusion mutuelle** (`TP/TP15`, mars 2026). En C avec les threads POSIX : une situation de compétition sur un compteur partagé, sa correction avec un mutex, l'algorithme de Peterson et un tri rapide parallèle avec une file de travail partagée, mesures de temps à l'appui.

## 6. Données, apprentissage automatique et texte

- **TP13 — classification et images** (`TP/TP13`, janv. 2026). En OCaml : *k* plus proches voisins sur des chiffres manuscrits (matrice de confusion, taux d'erreur), quantification des couleurs d'une photo par *k*-moyennes, tramage de Floyd–Steinberg.
- **TP18 — segmentation en mots** (`TP/TP18`, mai 2026). D'après le « Sujet 0 » de CentraleSupélec (MPI). Un lexique construit à partir de romans français avec un arbre binaire de recherche en C, puis, en OCaml, découpage d'un texte sans espaces en la suite de mots la plus plausible par programmation dynamique avec mémoïsation.
- **TP16 — SQL** (`TP/TP16`, mars 2026). Travail sur `mondial.db` et `vapor.db` ; seules les bases de données sont conservées ici.

## 7. Débogage et mémoire

- **TP12 — chasse aux bugs** (`TP/TP12`, janv. 2026). Des programmes OCaml défectueux à diagnostiquer et à corriger (types, arbres, graphes, évaluation, lecture de fichiers, file de priorité), ainsi qu'une série « compagnon » en C sur les pointeurs, la libération de la mémoire, les comportements indéfinis, les chaînes, les listes et les arbres binaires de recherche.

---

## Remarques

- Certains dossiers contiennent des fichiers compilés (`.cmo`, `.cmi`, exécutables) ou de gros fichiers de données (romans, bases de données, images), fournis avec les sujets ou produits lors des tests.
- Les énoncés originaux sont à attribuer au cours de mes professeurs et, le cas échéant, au site des concours CentraleSupélec.

    Sources :
    - http://cdn.sci-phy.org/mp2i/
    - https://github.com/nathaniel-carre/MPI-LLG
    - https://www.ens.psl.eu/rapports-et-sujets-2025-info-mpi
    - https://concours-centrale-supelec.fr/sujets-rapports