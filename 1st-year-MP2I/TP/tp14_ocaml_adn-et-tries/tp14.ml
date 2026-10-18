type base = A | C | G | T;;

type trie = Nil | Node of bool * trie * trie * trie * trie

let rec count = function
| Nil -> 0
| Node (b, c1, c2, c3, c4) -> (if b then 1 else 0) + (count c1) + (count c2) + (count c3) + (count c4)


let subtree base = function
| Nil -> Nil
| Node (_, a, c, g, t) -> match base with
  | A -> a
  | C -> c
  | G -> g
  | T -> t


let rec mem lst t = match lst t when
| _, Nil -> false
| [], Node(b,_,_,_,_) -> b
| h::tl, t -> mem tl (subtree h t)

let subst base tA tS = match base, tA with
| A, Nil -> Node(false, tS, Nil, Nil, Nil)
| C, Nil -> Node(false, Nil, tS, Nil, Nil)
| G, Nil -> Node(false, Nil, Nil, tS, Nil)
| T, Nil -> Node(false, Nil, Nil, Nil, tS)
| A, Node(b, _, c, g, t) -> Node(b, tS, c, g, t)
| C, Node(b, a, _, g, t) -> Node(b, a, ts, g, t)
| G, Node(b, a, c, _, t) -> Node(b, a, c, tS, t)
| T, Node(b, a, c, g, _) -> Node(b, a, c, g, tS)

let add lst tr = match lst, tr with
| [], Nil -> Nil
| [], Node(_, a, c, g, t) -> Node(true, a, c, g, t)
| lst, Nil -> add lst (Node (false, Nil, Nil, Nil, Nil))
| h::tl, Node (b, a, c, g, t) -> match h with
  | A -> Node (b, add tl a, c, g, t)
  | C -> Node (b, a, add tl c, g, t)
  | G -> Node (b, a, c, add tl g, t)
  | T -> Node (b, a, c, g, add tl t)


let rec trie_of_list = function
| [] -> Nil
| h::t -> add h (trie_of_list t)


let list_of_trie trie =
  let rec aux acc = function
  | Nil -> []
  | Node (b, a, c, g, t) -> let rest = (aux (A::acc) a )@(aux (C:acc) c)@(aux (G::acc))@(aux (T::acc)) in
                            if b then (List.rev acc)::rest
                            else rest
  in
  aux [] trie

let print_base b =
  print_char ((function A -> 'A'|C -> 'C'|G -> 'G'|T->'T') b)

let print_fragm = List.iter print_base

let display tree = List.iter (fun frag -> print_fragm frag; print_new_line ()) (list_of_trie tree)

let sort lst = list_of_trie (trie_of_list lst)

let remove 