type 'a t_array = Nil | Node of 'a t_array * int * 'a t_array

let example_t_array = Node(Node(Nil, 37, Nil),42,Node(Nil, 57, Nil))

let t = Node(
          Node(
            Node(Nil, 1, Nil),
            2,
            Node(Nil, 4, Nil)
          ),
          5,
          Node(
            Node(Nil, 6, Nil),
            7,
            Node(
              Node(Nil, 8, Nil),
              9,
              Node(Nil, 10, Nil)
            )
          )
        )

let rec length = function
| Nil -> 0
| Node (lc, _, rc) -> 1 + length lc + length rc

exception Found of int
exception Out_of_bounds
let get i t_array =
  let rec dfs k = function
  | Nil -> k
  | Node(lc, x, rc) -> let k' = 1 + dfs k lc in
                       if k' = i+1 then raise (Found x)
                       else dfs k' rc
  in try ignore (dfs 0 t_array); raise Out_of_bounds
  with Found x -> x

let concat t1 t2 =
  if t1 = Nil then t2 else

  let rec last_and_rest = function
  | Nil -> failwith "Empty"
  | Node(lc, x, Nil) -> x, lc
  | Node(lc, x, rc) -> let last, rest = last_and_rest rc in
                       last, Node(lc, x, rest) in
  let new_root, new_left = last_and_rest t1 in
  Node(new_left, new_root, t2)

let rec delete i t_array =
  let rec dfs k = function
  | Nil -> k, Nil
  | Node(lc, x, rc) -> let k', new_left = dfs k lc in
                        if k' = -1 then -1, Node(new_left, x, rc)
                        else if k' = i then -1, concat lc rc
                        else let k'', new_right = dfs (k'+1) rc in k'', Node(lc, x, new_right)
  in match dfs 0 t_array with
  | -1, t_deleted -> t_deleted
  | k, _          -> raise Out_of_bounds

let rec insert i elem t_array =
  let rec dfs k = function
  | Nil -> k, Nil
  | Node(lc, x, rc) -> let k', new_left = dfs k lc in
                        if k' = -1 then -1, Node(new_left, x, rc)
                        else if k' = i then -1, Node(lc, elem, Node(Nil, x, rc))
                        else let k'', new_right = dfs (k'+1) rc in k'', Node(lc, x, new_right)
  in match dfs 0 t_array with
  | -1, t_inserted -> t_inserted
  | k, _           -> raise Out_of_bounds