let rec foo f = function
| t::q when f t q -> foo f q
| t::q -> t::(foo f q)
| _ -> []

let doublons = foo (fun elem lst -> not (List.mem elem lst))

let _ = doublons [1; 2; 3; 2; 4; 5; 4]