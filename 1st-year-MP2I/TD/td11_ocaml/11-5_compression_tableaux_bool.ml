type bool_array =
| Node of int * bool_array * bool_array
| Leaf of bool

let arr = Node (7,
            Node(3,
              Leaf false,
              Leaf true
            ),
            Node(4,
              Node(2,
                Leaf true,
                Leaf false
              ),
              Node(2,
                Leaf true,
                Leaf false
              )
            )
          )

let rec get i = function
| Leaf b -> b
| Node (n, lc, rc) ->
    let m = n/2 in
    if i < m then
      get i lc
    else
      get (i-m) rc

let rec any i j = function
| Leaf b -> b && i=0 && j > i
| Node (n, lc, rc) ->
    let m = n/2 in
    any i (min m j) lc || any (max 0 (i-m)) (j-m) rc


let rec all = function
| Leaf b -> b
| Node (_, lc, rc) -> all lc && all rc
