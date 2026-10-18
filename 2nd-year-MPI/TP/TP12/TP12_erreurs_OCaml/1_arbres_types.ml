type 'a arbre = V | Noeud of 'a * 'a arbre * 'a arbre

let rec hauteur a = match a with
  |V -> -1
  |Noeud(_,g,d) -> 1 + max (hauteur g) (hauteur d)

let a = Noeud('a', Noeud('r', Noeud('t',V, V), V), Noeud('b', V, V))
let _ = hauteur a
