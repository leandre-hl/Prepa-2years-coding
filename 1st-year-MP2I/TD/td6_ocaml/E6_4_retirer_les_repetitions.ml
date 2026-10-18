let rec remove_ditto = function
| h1::h2::t when h1 = h2 -> remove_ditto (h2::t)
| h1::h2::t -> h1::(remove_ditto (h2::t))
| lst -> lst