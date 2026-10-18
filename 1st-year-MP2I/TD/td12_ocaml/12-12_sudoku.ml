let possibles sudoku i j =
  let available = Array.make 10 true in
  for k = 0 to 8 do
    available.(sudoku.(i).(k))                     <- false;
    available.(sudoku.(k).(j))                     <- false;
    available.(sudoku.(i/3*3 + k/3).(j/3*3 + k mod 3)) <- false
  done;
  List.filter (fun i -> available.(i)) (List.init 9 (fun i -> i+1))

let resout sudoku =
  let rec dfs k =
    if k = 81 then true else
    let i,j = k/9, k mod 9 in
    if sudoku.(i).(j) <> 0 then dfs (k+1) else 
    let poss = possibles sudoku i j in
    let rec loop = function
    | [] -> false
    | h::t -> sudoku.(i).(j) <- h;
              if dfs (k+1)
                then true
                else (sudoku.(i).(j) <- 0; loop t)
    in loop poss
  in dfs 0