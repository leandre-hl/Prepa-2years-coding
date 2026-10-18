let rec diff1 = function
| h1::h2::t -> (h2-h1)*diff1 (h2::t)
| _ -> 1
