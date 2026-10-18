let rec sum f n = match n with
| 0 -> 0
| _ -> f n + sum f (n-1)

let rec triangular n = sum (function k->k) n

let rec tetrahedral n = sum triangular n;;
Printf.printf "Tetrahedral de 1000 = %d\n" (tetrahedral 1000)