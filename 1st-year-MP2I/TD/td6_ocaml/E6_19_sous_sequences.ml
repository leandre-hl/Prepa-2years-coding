let rec firsts_and_rest lst n = match lst,n with
| l, 0 -> [], l
| [], n -> [], []
| h::t, n -> let l, rest = firsts_and_rest t (n-1) in h::l, rest

let rec subsequences lst n = match firsts_and_rest lst n with
| l, [] -> [l]
| l, _ -> l::subsequences (List.tl lst) n
