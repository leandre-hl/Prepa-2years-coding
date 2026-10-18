type bool_tree =
| Leaf of bool
| Node of bool * bool_tree * bool_tree

let rec true_branch = function
| Leaf b -> b
| Node (b, lc, rc) -> b && (true_branch lc || true_branch rc)

let rec mostly_true = function
| Leaf b -> b
| Node (b, lc, rc) -> mostly_true lc && mostly_true rc


