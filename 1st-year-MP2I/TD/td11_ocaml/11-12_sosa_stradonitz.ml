type 'a tree = Nil | Node of 'a tree * 'a * 'a tree

let path i =
  let rec aux acc = function
  | n when n <= 1 -> acc
  | n -> aux ((if n mod 2=0 then 'l' else 'r')::acc) (n/2)
  in aux [] i