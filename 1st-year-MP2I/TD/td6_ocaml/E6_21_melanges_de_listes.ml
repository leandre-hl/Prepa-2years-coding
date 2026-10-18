
let rec shuffles lst =
  let rec insert_at_all_pos x = function
  | [] -> [[x]]
  | h::t -> (x::h::t) :: List.map (fun lst -> h::lst) (insert_at_all_pos x t)
in match lst with
  | [] -> [[]]
  | h::t -> List.fold_right (fun l1 l2 -> insert_at_all_pos h l1 @ l2) (shuffles t) []