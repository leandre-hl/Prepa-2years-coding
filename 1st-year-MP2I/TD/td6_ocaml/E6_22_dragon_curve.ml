let next lst = 
  let rec insert n l = match n, l with
  | n, [] -> [n]
  | 0, h::t -> 0::h::insert 1 t
  | n, h::t -> 1::h::insert 0 t
  in insert 0 lst

let rec nth_term = function
| 0 -> []
| n -> next (nth_term (n-1))
let dist_dragon n =
  let rec dist x y ang = function
  | [] -> x, y
  | h::t -> 
    let next_ang = (ang + 5 - 2*h) mod 4 in
    match next_ang with
    | 0 -> dist (x+1) y next_ang t
    | 1 -> dist x (y+1) next_ang t
    | 2 -> dist (x-1) y next_ang t
    | n -> dist x (y-1) next_ang t
  in let list = nth_term n
  in let x, y = dist 1 0 0 list in
  let n = float_of_int (List.length list + 1) in
  sqrt ((float_of_int x /. n)**2. +. (float_of_int y /. n)**2.) 