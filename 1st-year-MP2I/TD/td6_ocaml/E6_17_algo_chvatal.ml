let transforme lst =
  let rec aux n lst = match n, lst with
  | n, _ when n<=0 -> [], lst
  | _, [] -> failwith "Pas assez d'éléments"
  | n, h::t -> let fst, snd = aux (n-1) t in h::fst, snd
in let l1, l2 = aux (List.hd lst) lst in List.rev_append l1 l2


let rec transforme_itere = function
| 1::t -> 1::t
| lst -> transforme_itere (transforme lst)