(* On reprend le code du E5.15 pour faciliter le travail*)

type 'a rle =
  | One of 'a
  | Many of int * 'a

let rec encode = function
| [] -> []
| [h] -> [One h]
| h1::h2::t -> match encode (h2::t) with
  | One h::q when h = h1 -> Many (2, h1)::q
  | Many (n, h)::q when h = h1 -> Many (n+1, h1)::q
  | h::q -> (One h1)::h::q
  | _ -> failwith "Cas impossible"

let next_iter list =
  let rec aux = function
  | [] -> []
  | One k::t -> 1::k::aux t
  | Many (n, k)::t -> n::k::aux t
  in aux (encode list)

let rec nth_iter start = function
| 0 -> start
| n -> nth_iter (next_iter start) (n-1)