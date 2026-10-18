let rec prod lst1 lst2 =
  let rec aux elem = function
    | [] -> []
    | h::t -> (elem, h)::aux elem t
  in match lst1 with
  | [] -> []
  | h::t -> aux h lst2 @ prod t lst2


  
let rec aux e = function
| [] -> []
| h::t -> (e,h)::aux e t

let prod lst1 lst2 = List.fold_right (fun e acc -> aux e lst2 @ acc) lst1 []