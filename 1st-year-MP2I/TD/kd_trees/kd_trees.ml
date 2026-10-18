type kdtree = Nil | Node of kdtree * (float * float) * kdtree

let tr = Node (
            Node (
              Node (Nil,(2., 6.), Nil),
              (4.,8.),
              Node(Nil, (5., 10.), Nil)
            ),
            (6.,4.),
            Node (
              Node (Nil, (9.,2.), Nil),
              (11., 3.),
              Node (Nil, (8., 10.), Nil)
            )
          )

let mem (x, y) tr =
  let rec aux vertical = function
  | Nil -> false
  | Node (lc, (x0, y0), rc) -> (x0, y0) = (x, y) ||
    (if (vertical && x <= x0) || (not vertical && y <= y0)
      then aux (not vertical) lc
      else aux (not vertical) rc)
  in aux true tr


let add (x, y) tr =
  let rec aux vertical = function
  | Nil -> Node(Nil, (x,y), Nil)
  | Node (lc, pos, rc) when pos = (x,y) -> Node (lc, pos, rc)
  | Node (lc, (x0, y0), rc) ->
    if (vertical && x <= x0) || (not vertical && y <= y0)
      then Node (aux (not vertical) lc, (x0, y0), rc)
      else Node (lc, (x0, y0), aux (not vertical) rc)
  in aux true tr


let kdtree_of_array = Array.fold_left (fun acc (x,y) -> add (x,y) acc) Nil


let rec count xmin xmax ymin ymax = function
  | Nil -> 0
  | Node (lc, (x, y), rc) ->
    (if xmin <= x && x <= xmax && ymin <= y && y <= ymax then 1 else 0) +
    count xmin xmax ymin ymax lc +
    count xmin xmax ymin ymax rc

exception Empty 
let rec xmin = function 
    | Nil -> raise Empty
    | Node (Nil, (x, _), _) -> x
    | Node (lc, _, _) -> xmin2 lc
and xmin2 = function
    | Nil -> raise Empty
    | Node (Nil, (x, _), Nil) -> x
    | Node (Nil, (x, _), rc)  -> min x (xmin rc)
    | Node (lc,  (x, _), Nil) -> min x (xmin lc)
    | Node (lc,  (x, _), rc)  -> min x (min (xmin lc) (xmin rc))


