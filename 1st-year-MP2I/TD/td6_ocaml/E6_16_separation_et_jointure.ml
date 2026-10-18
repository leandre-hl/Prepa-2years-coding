let split lst =
  let rec aux n = function
  | [] -> [], []
  | h::t -> let evens, odds = aux (n-1) t in 
  if n mod 2 = 0 then
    h::evens, odds
  else
    evens, h::odds
  in aux (List.length lst -1) lst

let rec interleave = function
| h1::t1, h2::t2 -> h1::h2::interleave (t1,t2)
| lst, [] -> lst
| [], lst -> lst

let rec zip = function
| h1::t1, h2::t2 -> (h1,h2)::zip (t1, t2)
| _ -> []