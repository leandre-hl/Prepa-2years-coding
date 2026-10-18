type 'a tree =
| Leaf of 'a
| Node of 'a * 'a tree * 'a tree

let rec minmax_tree = function
|Leaf a -> a, a
|Node (a, lchild, rchild) -> let lmin, lmax = minmax_tree lchild and rmin, rmax = minmax_tree rchild in
    min (min lmin rmin) a, max (max lmax rmax) a

let rec sum_tree = function
|Leaf a -> a
|Node (a, lchild, rchild) -> a + (sum_tree lchild) + (sum_tree rchild)


let rec count elem = function
|Leaf a -> if a = elem then 1 else 0
|Node (a, lchild, rchild) -> (count elem lchild) + (count elem rchild) + (count elem (Leaf a))


