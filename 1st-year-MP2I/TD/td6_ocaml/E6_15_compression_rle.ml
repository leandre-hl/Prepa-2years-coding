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

let rec decode = function
| [] -> []
| One h::t -> h::decode t
| Many (1, h)::t -> h::decode t
| Many (n, h)::t -> h::decode (Many (n-1, h)::t)

let rec sum_rle = function
| [] -> 0
| One h::t -> h + (sum_rle t)
| Many (n, h)::t -> n*h + (sum_rle t)

let rec nth_rle k lst = match k, lst with
| 0, One h::_ -> h
| k, Many (n, h)::_ when k < n -> h 
| k, [] -> failwith "Index out of range"
| k, One _::t -> nth_rle (k-1) t
| k, Many (n, _)::t -> nth_rle (k-n) t