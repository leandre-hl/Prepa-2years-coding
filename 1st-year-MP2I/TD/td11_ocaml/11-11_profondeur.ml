type 'a tree = Nil | Node of 'a tree * 'a * 'a tree

let t1 = Node(Node(Nil, 1, Nil), 2, Node(Nil, 3, Nil))
let t2 = Node(Node(Nil, 1, Nil), 2, Node(Nil, 3, Node(Nil, 4, Nil)))


let rec is_strict = function
| Nil -> true
| Node(Nil, _, Nil) -> true
| Node(Nil, _, _) -> false
| Node(_, _, Nil) -> false
| Node(lc, _, rc) -> is_strict lc && is_strict rc


let is_level tree =
  let rec test_and_height = function
  | Nil -> true, 0
  | Node(lc, _, rc) -> let lb, lh = test_and_height lc
                       and rb, rh = test_and_height rc in
                       lb && rb && lh = rh, lh+1
  in fst (test_and_height tree)