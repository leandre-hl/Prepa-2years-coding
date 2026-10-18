type 'a tree = Nil | Node of 'a tree * 'a * 'a tree
(*
3
  6
 4 8
    10
*)
let t = Node(
          Nil,
          3,
          Node(
            Node(Nil,4,Nil),
            6,
            Node(Nil, 8, Node(Nil, 10, Nil))
          )
         )

let rec min_depth = function
| Nil -> -1
| Node (Nil, _, rc) -> 1 + min_depth rc
| Node (lc, _, Nil) -> 1 + min_depth lc
| Node (lc, _, rc) -> 1 + min (min_depth lc) (min_depth rc)

exception Empty
let farthest tree =
  let rec depth_with_elem = function
  | Nil -> raise Empty
  | Node(lc, x, rc) -> let l_tuple = (try depth_with_elem lc with Empty -> -1, x) in
                       let r_tuple = (try depth_with_elem rc with Empty -> -1, x) in
                       max l_tuple r_tuple
  in snd (depth_with_elem tree) 