type 'a tree = Nil | Node of 'a tree * 'a * 'a tree

let prune tree n =
  if n<0 then Nil else
  let rec aux depth = function
  | Nil -> Nil
  | Node (lc, x, rc) -> if depth = n
                          then Node(Nil, x, Nil)
                          else Node(aux (depth+1) lc, x, aux (depth+1) rc)
  in aux 0 tree