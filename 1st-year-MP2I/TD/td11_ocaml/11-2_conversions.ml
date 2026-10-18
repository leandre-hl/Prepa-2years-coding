type 'a gen_tree =
  Gen_Node of 'a * 'a gen_tree list

type 'a tree =
| Leaf of 'a
| Node of 'a * 'a tree * 'a tree

let rec bin_of_gen = function
| Gen_Node (a, []) -> Leaf a
| Gen_Node (a, [lc; rc]) -> Node (a, bin_of_gen lc, bin_of_gen rc)
| _ -> failwith "Pas binaire strict"

let rec gen_of_bin = function
| Leaf a -> Gen_Node (a, [])
| Node (a, lc, rc) -> Gen_Node (a, [gen_of_bin lc; gen_of_bin rc])

