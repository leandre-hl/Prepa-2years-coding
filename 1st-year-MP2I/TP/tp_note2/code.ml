type gr = int list array

let u0 = ref 42;; (* Si vous revalidez cette ligne, il faut revalider tout 
                     le reste ! Si vous voulez changer u0, vous pouvez 
                     simplement écrire u0 := XXX *)

let u =
  let mem = Array.make 500000 0 in
  function n ->
    if mem.(0) <> !u0 then
      begin 
        mem.(0) <- !u0;
        for i = 1 to 499999 do
          mem.(i) <- 19_999_999 * mem.(i-1) mod 19_999_981
        done;
      end;
    mem.(n);;

let v p t = if u t mod 10000 < p then 1 else 0;;

let count_edges n p =
  let count = ref 0 in
  for t = 0 to n*(n-1)/2 -1 do
    if v p t = 1 then incr count
  done;
  !count;;

let build_gr n p =
  let gr = Array.make n [] in
  let t = ref 0 in
  for i = 0 to n - 1 do
    for j = i + 1 to n - 1 do
      if v p !t = 1 then
        begin
          gr.(i) <- j::gr.(i);
          gr.(j) <- i::gr.(j);          
        end;
      incr t;
    done;
  done;
  gr;;

let rec find arr i =
  if arr.(i) = i
    then i
    else begin let boss = find arr arr.(i) in arr.(i) <- boss; boss end;;

let union arr i j =
  let ri = find arr i in
  let rj = find arr j in
  if ri <> rj then arr.(rj) <- ri

let connex_array n p =
  let arr = Array.init n (fun i -> i) in
  let gr = build_gr n p in
  for i = 0 to n-1 do
    let rec unify = function
    | [] -> ()
    | j::rest -> union arr i j; unify rest
    in unify gr.(i)
  done;
  for i = 0 to n-1 do
    arr.(i) <- find arr i;
  done;
  arr;;

let size_0 n p =
  let chefs = connex_array n p in
  let count = ref 0 in
  for i = 0 to n-1 do
    if chefs.(i) = chefs.(0) then incr count
  done;
  !count;;


let count_nb_connex n p =
  let chefs = connex_array n p in
  let seen = Array.make n false in
  let count = ref 0 in
  for i = 0 to n-1 do
    if not (seen.(chefs.(i)))
      then (seen.(chefs.(i)) <- true; incr count)
  done;
  !count;;

let build_gr2 n p =
  let gr = build_gr n p in
  for i = 0 to n-2 do
    if not (List.mem (i+1) gr.(i)) then (gr.(i) <- i+1::gr.(i); gr.(i+1) <- i::gr.(i+1))
  done;
  for i = 0 to n-1 do
    gr.(i) <- List.sort compare gr.(i)
  done;
  gr;;

let nb_mouv_to_piece_and_piece n p pieces k =
  let gr = build_gr2 n p in
  let from = Array.make n (-1) in
  let queue = Queue.create () in
  Queue.push k queue;
  from.(k) <- k;
  while not (Queue.is_empty queue) && not pieces.(Queue.top queue) do
    let i = Queue.pop queue in
    List.iter
      (fun x -> if from.(x) = -1 then (from.(x) <- i; Queue.push x queue))
      gr.(i)
  done;
  if Queue.is_empty queue then failwith "no pieces"
  else
    let j = Queue.pop queue in
    let rec count = function
    | i when i = k -> 0
    | i -> 1 + count from.(i)
    in count j, j;;


let nb_mouvs n p k =
  let pieces = Array.init n (fun i -> i >= n - k) in
  let nb = ref 0 in
  let curr = ref 0 in
  for i = 0 to k-1 do
    let nb_moves, piece = nb_mouv_to_piece_and_piece n p pieces !curr in
    nb := !nb + nb_moves;
    curr := piece;
    pieces.(piece) <- false;
  done;
  !nb;;

(* Question 1 *)
u0 := 42;
Printf.printf "Question 1, seed %d : %d %d %d\n"
              !u0 (u 123 mod 1000) (u 456 mod 1000) (u 789 mod 1000);;
u0 := 37;
Printf.printf "Question 1, seed %d : %d %d %d\n"
              !u0 (u 123 mod 1000) (u 456 mod 1000) (u 789 mod 1000);;

(* Question 2 *)
u0 := 42; ();;
Printf.printf "Question 2, seed %d : %d %d %d\n"
              !u0 (count_edges 10 654) (count_edges 100 543) (count_edges 1000 12);;
u0 := 37;
Printf.printf "Question 2, seed %d : %d %d %d\n"
              !u0 (count_edges 10 654) (count_edges 100 543) (count_edges 1000 12);;

(* Question 3 *)
u0 := 42; ();;
Printf.printf "Question 3, seed %d : %d %d %d\n"
              !u0 (size_0 10 654) (size_0 100 543) (size_0 1000 12);;
u0 := 37;
Printf.printf "Question 3, seed %d : %d %d %d\n"
              !u0 (size_0 10 654) (size_0 100 543) (size_0 1000 12);;
(* Question 4 *)
u0 := 42; ();;
Printf.printf "Question 4, seed %d : %d %d %d\n"
              !u0 (count_nb_connex 10 654) (count_nb_connex 100 543) (count_nb_connex 1000 12);;
u0 := 37;
Printf.printf "Question 4, seed %d : %d %d %d\n"
              !u0 (count_nb_connex 10 654) (count_nb_connex 100 543) (count_nb_connex 1000 12);;

(* Question 5 *)
u0 := 42; ();;
Printf.printf "Question 5, seed %d : %d %d %d\n"
              !u0 (nb_mouvs 100 32 10) (nb_mouvs 200 21 15) (nb_mouvs 1000 1 20);;
u0 := 37;
Printf.printf "Question 5, seed %d : %d %d %d\n"
              !u0 (nb_mouvs 100 32 10) (nb_mouvs 200 21 15) (nb_mouvs 1000 1 20);;
