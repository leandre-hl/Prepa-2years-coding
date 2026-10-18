type graphe = int list array

let g1 = [|
  [6;8]; (*0*)
  [5];   (*1*)
  [3;8]; (*2*)
  [2];   (*3*)
  [8];   (*4*)
  [1];   (*5*)  
  [0;8]; (*6*)
  [];    (*7*)
  [0;2;4;6](*8*)
|];;

let g2 = [|
  [4;5]; (*0*)
  [2;3;6]; (*1*)
  [7];   (*2*)
  [2;9]; (*3*)
  [3;5]; (*4*)
  [];    (*5*)
  [8];   (*6*)
  [2];   (*7*)
  [1;6]; (*8*)
  [0]    (*9*)
|];;

let g3 = [|
  [2;9]; (*0*)
  [8];   (*1*)
  [0;5]; (*2*)
  [7];   (*3*)
  [9];   (*4*)
  [2];   (*5*)
  [8];   (*6*)
  [3];   (*7*)
  [1;6]; (*8*)
  [0;4;10];(*9*)
  [9]    (*10*)

|];;

let g4 = [|
  [7];   (*0*)
  [4];   (*1*)
  [0;6]; (*2*)
  [1;2;5];(*3*)
  [7];   (*4*)
  [4];   (*5*)
  [7];   (*6*)
  [];    (*7*)
|];;

let composantes_connexes (g:graphe) : int list list =
  let n = Array.length g in
  let vus = Array.make n false in
  let res = ref [] in
  let rec dfs s acc =
    if vus.(s) then acc else
      (vus.(s) <- true;
      s::List.fold_left (fun acc' x -> dfs x acc') acc g.(s))
    in
  for s = 0 to n-1 do
    if not vus.(s) then
      res:= (dfs s [])::!res
  done;
  !res;;


let acyclique_no (g:graphe) : bool = 
  let n = Array.length g in
  let nb_arretes = (Array.fold_left (fun acc x -> acc + List.length x) 0 g) / 2 in
  let nb_cc = List.length (composantes_connexes g) in
  nb_arretes = n - nb_cc


let numeros_dfs (g:graphe) : int array * int array =
  let n = Array.length g in
  let pre = Array.make n (-1) in
  let post = Array.make n (-1) in
  let k = ref (-1) in
  let rec dfs s =
    if pre.(s) = -1 then begin
      incr k;
      pre.(s) <- !k;
      List.iter dfs g.(s);
      incr k;
      post.(s) <- !k
    end in
  for i = 0 to n-1 do
    dfs i
  done;
  pre, post;;


let acyclique_o (g:graphe) : bool =
  let n = Array.length g in
  let bgn = Array.make n (-1) in
  let res = ref true in
  let rec dfs s =
    if !res then begin
      if bgn.(s) = 0 then res := false
      else if bgn.(s) = -1 then begin
        bgn.(s) <- 0;
        List.iter dfs g.(s);
        bgn.(s) <- -1
      end
    end in
  for i = 0 to n-1 do
    dfs i
  done;
  !res;;

      
let ordre_topo (g: graphe) : int array =
  let n = Array.length g in
  let _, post = numeros_dfs g in
  let tmp = Array.make (2*n) (-1) in
  for i = 0 to n-1 do
    tmp.(post.(i)) <- i
  done;
  let ordre = Array.make n (-1) in
  let i = ref 0 in
  for j = 0 to 2*n-1 do
    if tmp.(j) <> -1 then
      (incr i; ordre.(n - !i) <- tmp.(j))
    done;
    ordre;;



let transpose (g:graphe) : graphe =
  let n = Array.length g in
  let gt = Array.make n [] in
  let rec reverse i = function
  | [] -> ()
  | j::t -> (gt.(j) <- i::gt.(j); reverse i t)
  in
  for i=n-1 downto 0 do
    reverse i g.(i)
  done;
  gt;;

let kosaraju (g:graphe) : int list list =
  let n = Array.length g in
  let gt = transpose g in
  let l = ordre_topo gt in
  let vus = Array.make n false in
  let rec dfs s acc =
    if vus.(s) then acc else
      (vus.(s) <- true;
      s::List.fold_left (fun acc' x -> dfs x acc') acc g.(s))
    in
  let res = ref [] in
  for i = 0 to n-1 do
    let s = l.(i) in
    if not vus.(s) then
      res:= (dfs s [])::!res
  done;
  !res;;

type litteral = Neg of int | Pos of int
type clause = litteral * litteral
type deux_fnc = clause list
type valuation = int array;;

let eval_litt (mu: valuation) = function
  | Pos k -> mu.(k)
  | Neg k -> 1 - mu.(k);;

let and_ a b = a*b;;
let or_ a b = a + b - a*b;;

let rec evalue (mu: valuation) = function
  | [] -> 1
  | (x, y)::t -> and_ (or_ (eval_litt mu x) (eval_litt mu y)) (evalue mu t);; 

let incremente (mu) : bool =
  let n = Array.length mu in
  let j = ref (n-1) in
  while !j >= 0 && mu.(!j) = 1 do
    mu.(!j) <- 0;
    decr j
  done;
  if !j <> -1 then mu.(!j) <- 1;
  !j <> -1;;

let modele (n: int) (phi: deux_fnc) : valuation option =
  let mu = Array.make n 0 in
  let rec loop () =
    if evalue mu phi = 1 then Some mu
    else if incremente mu then loop () else None
  in loop ();;
 
let graphe_implication n phi =
  let gr = Array.make (2*n) [] in
  let not' = function
    | Pos x -> Neg x
    | Neg x -> Pos x
  in let indice = function
    | Pos x -> x
    | Neg x -> x + n
  in let rec build_gr = function
    | [] -> ()
    | (a, b)::t -> gr.(indice (not' a)) <- indice b :: gr.(indice (not' a));
                   gr.(indice (not' b)) <- indice a :: gr.(indice (not' b));
                   build_gr t
  in build_gr phi;
  gr;;

let convertir k lcfc =
  let cfc = Array.make k (-1) in
  let curr_cfc = ref 0 in
  let numerote_cfc lst = List.iter (fun x -> cfc.(x) <- !curr_cfc) lst; incr curr_cfc in
  List.iter numerote_cfc lcfc;
  cfc;;


let deux_sat n phi =
  let gr = graphe_implication n phi in
  let lcfc = kosaraju gr in
  let cfc = convertir (2*n) lcfc in
  List.for_all (fun i -> cfc.(i) <> cfc.(i + n)) (List.init n (fun i -> i));;

let modele2 n phi =
  if deux_sat n phi
    then Some (
      let mu = Array.make n 0 in
      let gr = graphe_implication n phi in
      let lcfc = kosaraju gr in
      let ordre = List.flatten lcfc in
      List.iter (fun i -> mu.(i mod n) <- if i<n then 1 else 0) ordre;
      mu
      )
    else None;; 

let lire_formule str =
  let build_litteral str =
    let n = abs (int_of_string str) in
    if str.[0] = '+'
      then Pos n
      else Neg n
  in let build_clause str =
    match String.split_on_char ',' str with
    | [g; d] -> (build_litteral g, build_litteral d)
    | _ -> failwith "format invalide"
  in List.map build_clause (String.split_on_char ';' str);;

let lire_fichier file_name =
  let f = open_in file_name in
  let rec loop () =
    try
      match String.split_on_char ' ' (input_line f) with
        | [n; str] -> (int_of_string n, lire_formule str)::loop ()
        | _ -> failwith "format invalide"
    with
      | End_of_file -> []
  in let res = loop () in
  close_in f;
  res;;


(*
Printf.printf "composantes_connexes : \n";
composantes_connexes g1;;
composantes_connexes g3;;

Printf.printf "acyclique_no : \n";
acyclique_no g1;;
acyclique_no g3;;


Printf.printf "numeros_dfs : \n";
numeros_dfs g1;;
numeros_dfs g2;;
numeros_dfs g3;;
numeros_dfs g4;;

Printf.printf "acyclique_o : \n";
acyclique_no g1;;
acyclique_no g2;;
acyclique_no g3;;
acyclique_no g4;;

Printf.printf "ordre_topo : \n";
ordre_topo g1;;
ordre_topo g2;;
ordre_topo g3;;
ordre_topo g4;;

Printf.printf "transpose : \n";
transpose g1;;
transpose g2;;
transpose g3;;
transpose g4;;

Printf.printf "kosaraju : \n";
kosaraju g1;;
kosaraju g2;;
kosaraju g3;;
kosaraju g4;;


let phi0 = [(Neg 1, Neg 2); (Neg 0, Pos 2); (Pos 2, Pos 2); (Pos 1, Pos 0); (Neg 1, Pos 2)];;
let phi1 = [(Neg 0, Pos 3); (Pos 0, Neg 2); (Pos 1, Neg 2); (Pos 0, Pos 2); (Neg 1, Neg 0); (Neg 3, Pos 2)];;

Printf.printf "modele : \n";
modele 3 phi0;;
modele 4 phi1;;


Printf.printf "graphe_implication : \n";
graphe_implication 3 phi0;;
graphe_implication 4 phi1;;


Printf.printf "deux sat optimise : \n";
deux_sat 3 phi0;;
deux_sat 4 phi1;;

Printf.printf "modele 2 : \n";
modele2 3 phi0;;
modele2 4 phi1;;
*)



Printf.printf "modele 2 : \n";
lire_formule "-1,-2;-0,+2;+2,+2;+1,+0;-1,+2";;