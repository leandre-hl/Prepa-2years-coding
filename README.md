[🇫🇷 Français](README.fr.md) | [🇬🇧 English](README.md)

# Prépa coding — MP2I / MPI (2024–2026)

This repository gathers the programming work I produced during my two years of *classes préparatoires* (CPGE) in France: **MP2I** (first year) and **MPI** (second year). It is mostly a record of the exercises, lab sessions and take-home assignments I wrote in **OCaml**, **C** and **SQL**, from my first recursive functions to threads, automata and SAT solvers.

Nothing here is a single polished product: it is a trace of two years of learning algorithms and data structures by implementing them.

---

## What is a *prépa*? (for non-French readers)

*Classes préparatoires aux grandes écoles* ("prépa") are a **two-year, intensive post-secondary program** that sits between high school and the French *grandes écoles* (engineering schools such as École Polytechnique, CentraleSupélec, Mines, Ponts, etc.). Students do not study for a degree: they prepare for **highly competitive national entrance exams** (*concours*) that rank them for admission to those schools.

The workload is heavy and mostly theoretical: roughly 40 hours a week of lectures, tutorials, weekly oral examinations (*colles*), and frequent written tests. Computer science is one subject among mathematics, physics and others.

I followed the **MP2I → MPI** track:

| Year | Track | Stands for | Focus of the computer science course |
|------|-------|------------|--------------------------------------|
| 1st year | **MP2I** | *Mathématiques, Physique, Ingénierie et Informatique* | Programming (OCaml, C), recursion, data structures, trees, graphs, backtracking, dynamic programming, basic compression and SQL |
| 2nd year | **MPI** | *Mathématiques, Physique, Informatique* | Algorithmics and theory: graph algorithms, automata and regular expressions, formal grammars, logic and SAT, game strategies, concurrency, databases |

**Vocabulary used in this repo**

- **TD** (*travaux dirigés*): tutorial exercises worked through during class.
- **TP** (*travaux pratiques*): hands-on lab sessions on a computer.
- **DM** (*devoir maison*): take-home assignment, handed in for a grade.
- **TP noté**: graded, timed lab exam.

Several assignments came with starter code, data files or a PDF statement provided by my teachers. The solutions are mine.

---

## Repository layout

```
prepa-coding/
├── 1st-year-MP2I/
│   ├── TD/                    # tutorial exercises (OCaml and C)
│   ├── TP/                    # lab sessions (tp7 … tp22, tp_note2)
│   ├── DM/Puzzle-color/       # take-home project (own README inside)
│   └── algo_cours_implementation/
└── 2nd-year-MPI/
    ├── TP/                    # TP1 … TP18
    └── DM3/                   # take-home project on minimum spanning trees
```

**Languages:** OCaml (functional programming, trees, graphs, logic), C (memory management, pointers, performance, threads), SQL (queries on relational databases).

---

# First year — MP2I (Nov 2024 – Jun 2025)

The first year mixes **TD** (tutorial exercises), **TP** (labs) and one **DM**. Work is grouped by theme; dates are approximate.

## 1. Functional programming and recursion (OCaml)

- **TD5 — first recursion exercises** (`TD/td5_ocaml`, Nov 2024). The Tak function, tetrahedral numbers, factorial without multiplication, root finding by bisection, quaternions, 3D geometry, and a recursive fractal drawn in ASCII.
- **TP7 — sequences** (`TP/tp7_ocaml_suites`, Nov 2024). Sequences as a start value plus a function; the Syracuse sequence and cycle detection with Floyd's tortoise-and-hare.
- **TP8 — sets of natural numbers** (`TP/tp8_ocaml_entiers-naturels`, Dec 2024). Three representations (lists, finite-or-cofinite sets, predicates) with union, intersection, complement, inclusion.
- **TD6 — lists** (`TD/td6_ocaml`, Dec 2024 – Jan 2025). Highlights: run-length encoding, the Conway look-and-say sequence, polynomials as lists of monomials, rationals and Gaussian integers as records, interleavings and shuffles, subsequences, a prefix-reversal game (Chvátal's algorithm) and the dragon curve.

## 2. Data structures

- **TD10 — stacks** (`TD/td10_ocaml`, Feb 2025). Bracket-matching verification, stack rotations and reversals.
- **TD11 — binary trees** (`TD/td11_ocaml`, Mar – Apr 2025). Highlights: heap-style and Sosa–Stradonitz numbering, depth, symmetry, pruning, subtree search, merging, Strahler number, Knuth powers, the Stern–Brocot tree, a symbolic maths-expression evaluator, and a past-exam problem on increasing trees.
- **Binary heaps** (`TD/tas_binaires`, Mar 2025). Array ↔ tree conversion and a correctness check.
- **TP14 — DNA and tries** (`TP/tp14_ocaml_adn-et-tries`, Mar 2025). A 4-branch trie (A, C, G, T): membership, insertion, removal, conversion to lists, sorting through the trie.
- **TP15 — red-black trees** (`TP/tp15_c_arbres-rouges-noirs`, Mar 2025). In C: parent pointers, family relations (uncle, grandparent), invariant checks, rotations and insertion with repair.
- **k-d trees** (`TD/kd_trees`, Jun 2025). A 2-dimensional k-d tree with a membership test.

## 3. Backtracking, exact cover and puzzles

- **TP16 — N-queens** (`TP/tp16_ocaml_backtracking-sur-echiquiers`, Apr 2025). Backtracking on a chessboard.
- **TP17 — nonograms** (`TP/tp17_ocaml_nonogrammes`, Apr 2025). A picture-logic solver: enumerating valid arrangements of each row and column from its clues, on nine puzzles.
- **Sudoku solver** (`TD/td12_ocaml`, Apr 2025). Depth-first backtracking over candidate digits.
- **DM — Color puzzle** (`DM/Puzzle-color`, Apr 2025). Edge-matching puzzles: square pieces with coloured sides are rotated and arranged in a rectangle. OCaml backtracking solver tested from 2×2 to 7×7. Has its own README and git history.
- **TP18 — Dancing Links** (`TP/tp18_c_liens-danssants`, May 2025). Knuth's Algorithm X in C for exact cover, used on N-queens and Sudoku (a small generator turns a grid into an exact-cover instance).

## 4. Dynamic programming and greedy algorithms

- **TD12 — backtracking and DP in C** (`TD/td12_c`, May 2025). McNugget theorem, longest increasing subsequence, self-avoiding walks, self-describing arrays, Golomb rulers, optimal path in a grid, ribbon cutting, palindromic partitions.
- **TD13 — greedy algorithms** (`TD/td13_ocaml`, May 2025). Placing the fewest stations along a road so that every house is covered.
- **Floyd–Warshall** (`algo_cours_implementation/floyd-warshall.ml`, Aug 2025). All-pairs shortest paths.

## 5. Graphs and their applications

- **TD14 — graph theory** (`TD/td14_ocaml`, May – Jun 2025). Reversal and symmetrisation of directed graphs, sinks, short cycles, Eulerian circuits, connected-component partitioning.
- **TP19 — mazes** (`TP/tp19_ocaml_labyrinthes`, Jun 2025). Maze generation as spanning trees (randomised DFS and Kruskal), "perfect maze" checks, path finding, drawing with Graphics and in ASCII.
- **TP20 — bus routes** (`TP/tp20_c_trajets-en-bus`, Jun 2025). Real timetable data: next departures, reachable stops, then Dijkstra and A* with a binary-heap priority queue.
- **Petri nets** (`TD/petri`, Jun 2025). Finding enabled transitions and firing them.
- **TP noté 2 — graded lab** (`TP/tp_note2`, Jun 2025). Timed exam on random graphs: pseudo-random edge generation, union-find, component statistics, a counting problem.

## 6. Compression, randomness, geometry and strings

- **TP10 — pseudo-random generators** (`TP/tp10_c_pseudo-aleatoire`, Jan 2025). Knuth's LCG, RANDU, MINSTD, a Mersenne Twister variant, compared with 2D/3D scatter plots (PPM images), OPSO, parking and matrix-rank tests.
- **TP11 — Bzip-style compression** (`TP/tp11_ocaml_compression_bzip`, Jan 2025). Burrows–Wheeler transform, frequency and run-length analysis to estimate compressed size.
- **TP12 — convex hulls** (`TP/tp12_c_enveloppes`, Feb 2025). Jarvis march and Graham scan in C, with a hand-written stack and sort.
- **TP22 — Huffman coding** (`TP/tp22_c_compression-hufmann`, Jun 2025). Frequencies, tree construction, code dictionary, bit-level file output, tree serialisation, decoding, compression ratio on text and DNA.
- **String ciphers** (`TD/chaines`, Jun 2025). A Vigenère-style encoder in C with a hand-written `strlen`.

## 7. C fundamentals, sorting and SQL

- **TD7 — arrays in C** (`TD/td7_c`, Jan 2025). Longest plateau, symmetry check, in-place reversal, cumulative sums and differences.
- **Coin systems** (`TD/systeme_monaitaire`, Jan 2025). Making change, with structs and dynamic arrays.
- **Sorting algorithms** (`algo_cours_implementation/tris.c`, revisited Mar 2026). Bubble (plain and optimised), insertion, selection, quick, merge and heap sort.
- **TP21 — SQL** (`TP/tp21_sql`, Jun 2025). Queries on a movie-rental database: `LIKE`, aggregates, `GROUP BY`, `ORDER BY`, joins.

---

# Second year — MPI (Sep 2025 – May 2026)

The second year has **no TD folder**: it consists of labs (TP) and one take-home project (DM3), grouped here by theme.

## 1. Refreshers

- **TP1 — OCaml** (`TP/TP1`, Sep 2025). List functions rewritten (`length`, `map`, `fold`, `partition`…), Fibonacci, binary and general trees with random generation, traversals and text display.
- **TP2 — C** (`TP/TP2`, Sep 2025). GCD, sieve of Eratosthenes, selection sort, binary search, linked lists, queues, inversion counting (naive vs. divide-and-conquer), resizable dynamic arrays.

## 2. Graph algorithms

- **TP3 — graphs** (`TP/TP3`, Sep 2025). In OCaml: connected components, cycle detection, DFS numbering, topological order, Kosaraju's strongly connected components (reused for 2-SAT, see below).
- **DM3 — minimum spanning trees** (`DM3`, Sep – Oct 2025). Two languages: **Kruskal** in OCaml (union-find by rank, hand-written quicksort) and **Borůvka** in C, tested with assertions on weighted graphs from 10 to 50,000 vertices.
- **TP4 — bipartite matching** (`TP/TP4`, Oct 2025). In C: augmenting paths, maximum matching, Hopcroft–Karp.

## 3. Automata, languages and logic

- **TP5 — finite automata** (`TP/TP5`, Oct 2025). In C: DFA and NFA, word recognition, determinisation by subset construction (including a version building only reachable states).
- **TP6 — regular expressions** (`TP/TP6`, Nov 2025). In OCaml: parser, simplification, linearisation, prefix/suffix/factor languages, Glushkov automaton.
- **TP11 — formal grammars** (`TP/TP11`, Jan 2026). In C: context-free grammars, Chomsky normal form check, CYK parsing.
- **SAT in TP3 and TP9** (`TP/TP3`, `TP/TP9`, Sep and Dec 2025). Brute-force SAT and 2-SAT via the implication graph; then MAX-SAT with random CNF formulas from a pseudo-random sequence, exact backtracking, random-assignment simulation and the method of conditional probabilities.
- **TP14 — propositional logic** (`TP/TP14`, Feb 2026). Formula evaluation, tautology checking, proof search with the sequent calculus.

## 4. Games and strategies

- **TP7 — generalised tic-tac-toe** (`TP/TP7`, Nov 2025). In C: *k* aligned marks on an *n*×*n* board, state encoding, optimal strategy through attractors with a memoisation dictionary.
- **TP8 — Connect Four** (`TP/TP8`, Nov 2025). In OCaml: coloured terminal display, random strategy, strategy comparison, heuristic depth-limited search.

## 5. Concurrency

- **TP15 — threads and mutual exclusion** (`TP/TP15`, Mar 2026). In C with POSIX threads: a race condition on a shared counter, its fix with a mutex, Peterson's algorithm, and parallel quicksort with a shared work queue, with timings.

## 6. Data, machine learning and text

- **TP13 — classification and images** (`TP/TP13`, Jan 2026). In OCaml: *k*-nearest-neighbours on handwritten digits (confusion matrix, error rate), *k*-means colour quantisation of a photo, Floyd–Steinberg dithering.
- **TP18 — word segmentation** (`TP/TP18`, May 2026). From the CentraleSupélec "Sujet 0" (MPI). A lexicon built from French novels with a binary search tree in C, then, in OCaml, splitting unspaced text into the most plausible words with memoised dynamic programming.
- **TP16 — SQL** (`TP/TP16`, Mar 2026). Practice on `mondial.db` and `vapor.db`; only the databases are kept here.

## 7. Debugging and memory

- **TP12 — finding bugs** (`TP/TP12`, Jan 2026). Broken OCaml programs to diagnose and fix (types, trees, graphs, evaluation, file reading, priority queue), plus a "companion" C series on pointers, memory release, undefined behaviour, strings, lists and binary search trees.

---

## Notes

- Some folders contain compiled files (`.cmo`, `.cmi`, executables) or large data files (novels, databases, images) that came with the assignments or were produced while testing.
- Original exercise statements are credited to my teachers' course material and to the CentraleSupélec concours website where relevant.

    Sources :
    - http://cdn.sci-phy.org/mp2i/
    - https://github.com/nathaniel-carre/MPI-LLG
    - https://www.ens.psl.eu/rapports-et-sujets-2025-info-mpi
    - https://concours-centrale-supelec.fr/sujets-rapports