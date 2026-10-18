
let rec fact_no_mult n = match n with
| 0 -> 1
| _ -> let rec fact_sum m = match m with
  | 0 -> 0
  | _ -> fact_no_mult (n-1) + fact_sum (m-1)
  in fact_sum n

let () =
  let a = int_of_string(read_line ()) in
  print_int a