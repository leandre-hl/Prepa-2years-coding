let rec p_count f = function
| h::t when f h -> 1 + p_count f t
| h::t -> p_count f t
| [] -> 0

let p_last f lst =
  let rec aux acc = function
  | h::t when f h -> aux (h::acc) t
  | h::t -> aux acc t
  | [] -> acc
in match aux [] lst with
| [] -> failwith "predicat toujours faux"
| h::t -> h

let rec p_antifilter f = function
| h::t when not (f h) -> h::p_antifilter f t
| h::t -> p_antifilter f t
| _ -> []