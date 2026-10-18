let rec insertions k lst =
  match lst with
  | [] -> [[k]]
  | hd :: tl ->
      (k :: lst) :: (List.map (fun l -> hd :: l) (insertions k tl))

let rec interleaves lst = function
| [] -> []
| h::t -> (insertions h lst) @ (interleaves lst t)