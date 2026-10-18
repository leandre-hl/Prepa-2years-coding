let multiply = List.fold_left ( * ) 1

let rec list_larger_than_2 = function
| n when n < 2 -> []
| n -> n::list_larger_than_2 (n-1)

let rec fact = function
| 0 -> 1
| n -> n * fact (n-1)

