let foo x y =
  let rec res = function
    | (x, y) when x > y -> 1
    | (x, y) -> 2 * res (x + 1, y - x - 1)
  in
  res (x, y)

let x = 5
let y = 1000

let () =
  Printf.printf "foo(%d, %d) = %d\n" x y (foo x y)
