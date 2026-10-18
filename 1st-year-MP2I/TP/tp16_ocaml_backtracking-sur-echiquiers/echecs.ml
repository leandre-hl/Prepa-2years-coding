let display n =
  List.iter (fun i ->
  let rec aux = function
  | 0 -> print_newline ()
  | j -> print_char (if i+j=n then 'X' else '.'); aux (j-1)
  in aux n)

let conflit (x1, y1) (x2, y2) =
  x1 = x2 || y1 = y2 || abs(x2-x1) = abs (y2-y1)

exception Exit
let verifie solution =
  let sol_arr = Array.of_list solution in
  let n = Array.length sol_arr in
  try
    for i = 0 to n-2 do
      for j = i+1 to n-1 do
        if conflit (i, sol_arr.(i)) (j, sol_arr.(j))
          then raise Exit
      done;
    done;
    true
  with Exit -> false

let rec suivant n = function
| [] -> None
| h::t -> if h<n-1
            then Some (h+1 :: t)
            else match suivant n t with
              | None -> None
              | Some rest -> Some (0::rest)


let acceptable n =
  let rec aux solution =
    if verifie solution
      then Some solution
    else match suivant n solution with
      | None -> None
      | Some suivant -> aux suivant
  in
  aux (List.init n (fun i -> 0))


let possible n lst =
  let lst_arr = Array.of_list lst in
  let k = Array.length lst_arr in
  let possibles = ref [] in
  for column = 0 to n-1 do
    try
      for i = 0 to k-1 do
        if conflit (n-k-1, column) (i, lst_arr.(i))
          then raise Exit
      done;
      possibles := column :: !possibles
    with Exit -> ()
  done;
  match !possibles with
  | [] -> None
  | lst -> Some (List.rev lst)

let rec explore n k lst =
  if k = n then
    Some lst
  else
    match possible n lst with
    | None -> None
    | Some possibles -> 
      let rec loop = function
      | [] -> None
      | i::t -> match explore n (k+1) (i::lst) with
                | None -> loop t
                | some -> some
      in loop possibles

  
