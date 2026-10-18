type litteral = Var of int | Neg of int
type clause = litteral list
type fnc = clause list

let phi = [[Neg 0; Var 1; Neg 2];
  [Var 0; Neg 1; Var 2];
  [Var 0; Var 1; Var 2];
  [Neg 0; Neg 1]]


let maxn = 10000000
let ut = Array.make maxn 0
let _ = ut.(0) <- 42
let maxind_u = ref 0

let u n =
  for i = !maxind_u + 1 to n do
    ut.(i) <- 19999999 * ut.(i-1) mod 19999981
  done;
  maxind_u := max !maxind_u n;
  ut.(n);;
  
(*
u 123 mod 1000;;
u 456000 mod 1000;;
u 789000000 mod 1000;;
*)

let sum_ut = Array.make maxn 0
let _ = sum_ut.(0) <- ut.(0)
let maxind_sum_u = ref 0
let sum_u n =
  for i = !maxind_sum_u + 1 to n do
    sum_ut.(i) <- (u i + sum_ut.(i-1)) mod 1000
  done;
  maxind_sum_u := max !maxind_sum_u n;
  sum_ut.(n);;

(*
sum_u 123 mod 1000;;
sum_u 45600 mod 1000;;
(*sum_u 78900000 mod 1000;;*)

*)

let rec clause i n k =
  let c = ref [] in
  for j = 0 to n-1 do  
    let r = u (i+j) mod (2*n) in
    if r < k then
      if r mod 2 = 0 then
        c := Var j :: !c
      else
        c := Neg j :: !c
  done;
  !c

let formule i n m k =
  List.init m (fun j -> List.rev (clause (i+j*n) n k));;

(* formule 0 3 4 2 *)


let rec evaluer c mu = match c with
  | [] -> false
  | Var i :: t -> mu.(i) || evaluer t mu
  | Neg i :: t -> not mu.(i) || evaluer t mu

let rec taille_J f mu = match f with
  | [] -> 0
  | c::t -> (if evaluer c mu then 1 else 0) + taille_J t mu
  
let maxsat_backtracking f n =
  let mu = Array.make n false in
  let res = ref (-1) in
  let rec explore i =
    if i = n then
      (let t = taille_J f mu in
      if !res < t then
        res := t)
    else begin
      explore (i+1);
      mu.(i) <- true;
      explore (i+1);
      mu.(i) <- false
    end
  in explore 0;
  !res;;

(*
maxsat_backtracking (formule 0 10 20 3) 10;;
maxsat_backtracking (formule 0 15 100 5) 15;;
maxsat_backtracking (formule 0 20 200 7) 20;;*)

let maxsat_alea i n = Array.init n (fun j -> u (i+j) mod 2 = 1)

let simulation f n m =
  let sum = ref 0. in
  for i' = 0 to m-1 do
    let i = n * i' in
    let j = float_of_int (taille_J f (maxsat_alea i n)) in
    sum := !sum +. j
  done;
  let j' = float_of_int (maxsat_backtracking f n) in
  !sum /. (float_of_int m) /. j';;

simulation (formule 0 10 20 3) 10 1000;;
simulation (formule 0 15 100 5) 15 1000;;
simulation (formule 0 20 200 7) 20 1000;;


let proba_condi c mu i =
  let k = ref 0 in
  let rec loop = function
  | [] -> 0.
  | Var j :: t when j <= i -> if mu.(i) then 1. else loop t
  | Neg j :: t when j <= i -> if not mu.(i) then 1. else loop t
  | Var j :: t | Neg j :: t -> incr k; loop t
  in 


