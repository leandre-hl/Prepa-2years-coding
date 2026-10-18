let diviseurs n = 
  let rec aux acc = function
    | i when i*i > n -> acc
    | i when i*i = n -> i::acc
    | i when n mod i = 0 -> i::aux ((n/i)::acc) (i+1)
    | i -> aux acc (i+1) in
  aux [] 1

let abondant n = List.fold_left (+) 0 (diviseurs n) >= 2*n

let abondants n =
  let rec aux n =
  if n = 0 then
    []
  else if abondant n then
    n::aux (n-1)
  else
    aux (n-1)
  in List.rev (aux n)