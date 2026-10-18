type tree = Nil | Node of tree * tree


let t = Node(Node(Nil, Node(Nil, Nil)), Nil)

let rec same_shape t1 t2 = match t1, t2 with
| Nil, Nil -> true
| Node(l1, r1), Node(l2, r2) -> same_shape l1 l2 && same_shape r1 r2
| _ -> false


let rec mirorred t1 t2 = match t1,t2 with
| Nil, Nil -> true
| Node(l1, r1), Node(l2, r2) -> mirorred l1 r2 && mirorred r1 l2
| _ -> false

let rec symetric t = mirorred t t

let rec flip = function
| Nil -> Nil
| Node(lc, rc) -> Node(flip rc, flip lc)