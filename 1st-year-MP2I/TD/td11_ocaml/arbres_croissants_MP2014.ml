type arbre = E | N of arbre * int * arbre

let minimum = function
| N (_, x, _) -> x
| E -> failwith "impossible"

let rec est_un_arbre_croissant = function
| E | N(E, _, E) -> true
| N(c, x, E)| N(E, x, c) -> est_un_arbre_croissant c && x <= minimum c
| N(g, x, d) -> est_un_arbre_croissant g && est_un_arbre_croissant d && x <= minimum g && x <= minimum d
let rec fusion t1 t2 = match t1, t2 with
| t, E -> t
| E, t -> t
| N(g1, x1, d1), N(g2, x2, d2) ->
      if x1 > x2 then
        N (fusion d2 (N(g1, x1, d1)), x2, g2)
      else
        N (fusion d1 (N(g2, x2, d2)), x1, g1)

let a = N (N(E,2,E), 1, N(E,4,E))
and b = N (N(E,5,E), 3, N(E,6,E))

let ajoute x = fusion (N (E,x,E))
let supprime_minimum = function
| E -> failwith "Arbre vide"
| N(g, x, d) -> fusion g d

let ajouts_successifs lst =
  let rec aux = function
  | [] -> E
  | x::t -> fusion (aux t) (N (E, x, E))
  in List.rev lst |> aux


let potentiel t =
  let rec size_and_pot = function
  | E -> 1, 0
  | N (g, _, d) -> let sg, pg = size_and_pot g and sd, pd = size_and_pot d in
                   if sg < sd then
                    1+sg+sd, 1 + pg + pd
                   else
                    1+sg+sd, pg + pd
  in size_and_pot t |> snd

let tri lst =
  let arbre = ref (ajouts_successifs lst) in
  let triee = ref [] in
  while !arbre <> E do
    triee := minimum !arbre::!triee;
    arbre := supprime_minimum !arbre
  done;
  List.rev !triee
