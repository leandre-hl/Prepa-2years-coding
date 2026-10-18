type 'a tree =
| Leaf of 'a
| Node of 'a * 'a tree * 'a tree

let t = Node(2,
          Node(3,
            Leaf 4,
            Node(5,
              Leaf 7,
              Leaf 11
            )
          ),
          Leaf 12
        )

let tree_numbering tree =
  let rec aux acc = function
  | Leaf a -> acc, Leaf (acc, a)
  | Node (a, lc, rc) ->
      let max_lft, new_lc = aux acc lc in
      let max_rht, new_rc = aux (max_lft + 2) rc in
      max_rht, Node ((max_lft + 1, a), new_lc, new_rc)
  in snd (aux 0 tree)

let tree_numbering2 tree =
  (* Copier l'arbre initial avec des ref *)
  let rec to_ref = function
    | Leaf a -> Leaf ((ref 0, a))
    | Node (a, lc, rc) -> Node ((ref 0, a), to_ref lc, to_ref rc)
  in let ref_tree = to_ref tree in

  (* Remplir la copie des bons indices*)
  let q = Queue.create () in
  Queue.push ref_tree q;
  let num = ref 0 in
  while not (Queue.is_empty q) do
    incr num;
    match Queue.pop q with
    | Leaf ((pos, _)) -> pos := !num
    | Node ((pos, _), lc, rc) ->
        pos := !num;
        Queue.push lc q;
        Queue.push rc q;
  done;

  (* Transformer l'arbre de références en normal *)
  let rec del_ref = function
    | Leaf (pos, a) -> Leaf (!pos, a)
    | Node ((pos, a), lc, rc) -> Node ((!pos, a), del_ref lc, del_ref rc)
  in del_ref ref_tree