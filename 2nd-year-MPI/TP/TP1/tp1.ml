Random.self_init ();;

let liste_alea k n =
  List.init n (fun i -> Random.int k);;

let test = [1;2;3;4];;

let rec length = function
| [] -> 0
| _::t -> 1 + length t;;


let test_length = length test;;

let rec mem a = function
| [] -> false
| h::t when h=a -> true
| _::t -> mem a t;;

let test_mem1 = mem 3 test;;
let test_mem2 = mem 5 test;;



let rec append t1 t2 = match t1 with
| [] -> t2
| h::t -> h:: append t t2;;

let test_append = append [-1;0] test;;


let rec map f = function
| [] -> []
| h::t -> (f h)::map f t;;

let test_map = map (fun i -> i+1) test;; 

let rec iter f = function
| [] -> ()
| h::t -> f h; iter f t;;

let test_iter = iter print_int test;;

let somme = List.fold_left (+) 0;;

let test_somme = somme test;;

let maximum = function
| [] -> failwith "liste vide"
| h::t -> List.fold_left max h t

let test_maximum1 = maximum [3;1;2];;
let test_maximum2 = maximum test;;


let rec partition f = function
| [] -> [], []
| h::t -> let a, b = partition f t in
          if f h then h::a, b else a, h::b;;
          
let test_partition = partition (function x -> x < 0) [-1; -2; 3; -4; 5];;

let fibo n =
  let rec aux = function
  | -1 -> failwith "fibo(-1) pas defini"
  | 0 -> [0]
  | 1 -> [1; 0]
  | n -> match aux (n-1) with
        | h1::h2::t -> (h1+h2)::h1::h2::t
        | _ -> failwith "cas impossible"
  in List.rev (aux n);;

let test_fibo1 = fibo 4;;
let test_fibo2 = fibo 60;;

#use "affichage_arbres.ml";;

let rec arbre_bin_alea_aux k = function
| 0 -> Vide
| n -> let size_left = Random.int n in
       let size_right = n - 1 - size_left in
       N (k, arbre_bin_alea_aux (k+1) size_left, arbre_bin_alea_aux (k + size_left + 1) size_right);;

let arbre_bin_alea = arbre_bin_alea_aux 0;;


let arbre = arbre_bin_alea 10;;
let test_arbre_bin_alea = afficher_arbre_bin arbre;;


let rec taille_bin = function
| Vide -> 0
| N (_, lc, rc) -> 1 + taille_bin lc + taille_bin rc;;

let test_taille_bin = taille_bin arbre;;

let rec hauteur_bin = function
| Vide -> -1
| N(_, lc, rc) -> 1 + max (hauteur_bin lc) (hauteur_bin rc);;

let test_hauteur_bin = hauteur_bin arbre;;

let rec affiche_prefixe = function
| Vide -> ()
| N(r, lc, rc) -> print_int r; affiche_prefixe lc; affiche_prefixe rc;;


let test_affiche_prefixe = affiche_prefixe arbre;;


let rec infixe1 = function
| Vide -> []
| N (r, lc, rc) -> infixe1 lc @ r::infixe1 rc

let rec test_infixe1 = infixe1 arbre;; 

let infixe2 a =
  let rec aux acc = function
  | Vide -> acc
  | N (r, lc, rc) -> aux (r::aux acc rc) lc
  in aux [] a;;
  
  
let rec test_infixe2 = infixe2 arbre;;


let rec vers_lst = function
| Vide -> []
| N(x, g, d) -> Noeud(x, vers_lst g) :: vers_lst d;;


let arbre_alea n =
  let a = arbre_bin_alea (n - 1) in
  Noeud(n - 1, vers_lst a);;

let arbre2 = arbre_alea 10;;
afficher_arbre arbre2;;

let rec taille = function
| Noeud (_, lst) -> 1 + List.fold_left (fun acc x -> acc + taille x) 0 lst

let test_taille = taille arbre2;;

let suffixe a =
  let rec aux acc = function
  | Noeud (r, lst) -> List.fold_left (fun acc' c -> aux acc' c) (r::acc) lst 
 in aux [] a;;

let test_suffixe = suffixe arbre2;;


let rec bin_vers_arbre = function
| Vide -> failwith "arbre vide"
| N(r, Vide, Vide) -> Noeud(r, [])
| N(r, Vide, rc) -> Noeud(r, [bin_vers_arbre rc])
| N(r, lc, Vide) -> Noeud(r, [bin_vers_arbre lc])
| N(r, lc, rc) -> Noeud(r, [bin_vers_arbre lc; bin_vers_arbre rc]);;


afficher_arbre_bin arbre;;
afficher_arbre (bin_vers_arbre arbre);;