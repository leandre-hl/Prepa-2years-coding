let rec suffixes = function
| [] -> []
| h::t -> (h::t)::suffixes t;;

suffixes [1; 2; 3]