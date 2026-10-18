type 'a tree = Leaf of 'a | Node of 'a tree * 'a * 'a tree

let rec strahler = function
| Leaf _ -> 1
| Node (lc, _, rc) -> let ls = strahler lc
                      and rs = strahler rc in
                      if ls = rs
                        then ls +1
                        else max ls rs