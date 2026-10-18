type 'a tree = {value:int; mutable children:'a tree list}

(* Génère l'arbre des puissances de Knuth en parcours en largeur jusqu'à une profondeur donnée *)
let knuth_power_tree depth =
  let used = Array.make (1 lsl (depth) + 1) false in (* Stockage des entiers déjà utilisés, la plus grande étiquette étant majorée par 2^(depth)*)

  let queue = Queue.create () in
  let root = {value = 1; children = []} in
  Queue.push (root, [1], 0) queue;

  while not (Queue.is_empty queue) do
    let node, ancestors, d = Queue.pop queue in
    if d < depth then
      (* On génère les enfants qui n'ont pas été pris, du plus petit au plus grand *)
      let children = List.fold_left
        (fun acc ai ->
          let child_val = node.value + ai in
          if used.(child_val)
            then acc
            else (used.(child_val) <- true; {value = child_val; children = []}::acc)  
        ) [] ancestors in 
      node.children <- children;
      List.iter (fun child -> Queue.push (child, child.value::ancestors, d+1) queue) children
  done;
  root

let ceil_log2 n =
  if n <= 0 then invalid_arg "n must be positive";
  let rec aux pow exp =
    if pow >= n then exp
    else aux (pow lsl 1) (exp + 1)
  in
  aux 1 0

let to_array n =
  let arr = Array.make n 0 in
  (* Flemme de faire sans arbre, je me suis pas fait chier à faire la première fonction pour rien *)
  let tree = knuth_power_tree (1 + ceil_log2 (n-1)) in (* On va oublier le fait que c'est débile de calculer un log pour déterminer une puissance *)
  let rec get_parent tr = List.iter (fun x -> if x.value < n then (arr.(x.value) <- tr.value; get_parent x)) tr.children
  in get_parent tree;
  arr

let pow x n =
  let parents = to_array (n+1) in
  let memo = Array.make (n+1) (-1) in

  let rec aux = function
  | 0 -> 1
  | 1 -> x
  | i -> if memo.(i) <> -1 then memo.(i) else
         let p = parents.(i) in
         let xi = (aux p) * (aux (i-p)) in
         memo.(i) <- xi; xi
  in aux n


