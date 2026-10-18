type 'a tree = Nil | Node of 'a tree * 'a * 'a tree

let t = Node(
          Node(Nil, 2, Nil),
          3,
          Node(
            Node(Nil,4,Nil),
            6,
            Node(Nil, 8, Nil)
          )
         )

(* La fonction revient à déterminer la plus petite hauteur des branches (se finissant sur un Nil) de l'arbre *)
let rec min_depth = function
| Nil -> -1
| Node (lc, _, rc) -> 1 + min (min_depth lc) (min_depth rc)

let max3 x y z = max x (max y z)
let max_node tree =
  let rec max_depth_and_elem = function
  | Nil -> failwith "empty tree"
  | Node(Nil, x, Nil) -> 0, x
  | Node(Nil, x, rc ) -> max_depth_and_elem rc
  | Node(lc , x, Nil) -> max_depth_and_elem lc
  | Node(lc , x, rc ) ->let l = max_depth_and_elem lc
                        and r = max_depth_and_elem rc in
                        let with_root = 1 + min (fst l) (fst r) in
                        max3 (with_root, x) l r
  in snd (max_depth_and_elem tree)
