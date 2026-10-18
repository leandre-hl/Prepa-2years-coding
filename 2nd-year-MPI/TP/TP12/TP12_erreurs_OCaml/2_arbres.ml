type 'a arbre = Vide | Noeud of 'a * 'a arbre * 'a arbre

let rec appartient a x = match a with
  |Vide -> false
  |Noeud(y,g,d) when y=x -> true
  |Noeud(_,g,d) -> (appartient g x) || (appartient d x)

let rec nb_differents a v = match a with
  |Vide -> 0
  |Noeud(r,g,d) when r = v -> nb_differents g v + nb_differents d v
  |Noeud(r,g,d) -> 1 + nb_differents g v + nb_differents d v

let rec hauteur a = match a with
  |Vide -> -1
  |Noeud(_,g,d) -> 1 + max (hauteur g) (hauteur d)

(*L'arbre en entrée vérifie que chaque noeud a une étiquette plus petite que celle de ses fils éventuels et on souhaite que cette propriété soit conservée.*)
let rec inserer a x = match a with
  |Vide -> Noeud(x, Vide, Vide)
  |Noeud(r,g,d) -> let hg = hauteur g and hd = hauteur d in
                  if hd <= hg then Noeud(min r x, g, inserer d (max r x))
                  else Noeud(min r x, inserer g (max r x), d)
