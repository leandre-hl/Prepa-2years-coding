let rec penultimate = function
| [h1, h2] -> h1
| h1::h2::t -> penultimate (h2::t)
| _ -> failwith "Trop court"

let rec firsts list k = match list, k with
| _, 0 -> []
| h::t, k -> h::firsts t (k-1)
| _ -> failwith "Trop court"

let rec remove list k = match list, k with
| h::t, 0 -> t
| h::t, k -> h::remove t (k-1)
| _ -> failwith "Trop court"

let rec insert list elem k = match list, k with
| lst, 0 -> elem::lst
| h::t, k -> h::insert t elem (k-1)
| _ -> failwith "Trop court"