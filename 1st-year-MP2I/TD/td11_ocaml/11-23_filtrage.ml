type 'a bst = Nil | Node of 'a bst * 'a * 'a bst

let t = Node(
          Node(
            Node(Nil, 1, Nil),
            2,
            Node(Nil, 4, Nil)
          ),
          5,
          Node(
            Node(Nil, 6, Nil),
            7,
            Node(
              Node(Nil, 8, Nil),
              9,
              Node(Nil, 10, Nil)
            )
          )
        )
let compare_fn = (>=) (* Compare_fn renvoie true si le premier argument est plus grand, false sinon *)

let rec filter a b compare_fn = function 
| Nil -> Nil
| _ when not (compare_fn b a) -> Nil
| Node (lc, elem, rc) ->  if compare_fn elem a && compare_fn b elem  (* a <= elem <= b : On cherche à gauche et à droite *)
                            then Node (filter a elem compare_fn lc, elem, filter elem b compare_fn rc)
                          else if not (compare_fn elem a)  (* elem < a : On cherche à droite *)
                            then filter a b compare_fn rc
                          else (* b > elem : On cherche à gauche *)
                            filter a b compare_fn lc