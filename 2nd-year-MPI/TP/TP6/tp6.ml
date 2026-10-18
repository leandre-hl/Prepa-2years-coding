(*open Regex;;*)

let rec normaliser = function
  | Union (r, g) ->
    (match normaliser r, normaliser g with
    | r', Vide -> r'
    | Vide, g' -> g'
    | r', g' -> Union (r', g')) 
  | Concat (r, g) -> 
    (match normaliser r, normaliser g with
    | r', Vide -> Vide
    | Vide, g' -> Vide
    | r', g' -> Concat (r', g'))
  | Etoile r ->
    (match normaliser r with
    | Vide -> Epsilon
    | r -> Etoile r)
  | r -> r;;

let est_vide r = normaliser r = Vide;;



let rec nombre_lettres = function
  | Union (r, g) | Concat (r, g) -> nombre_lettres r + nombre_lettres g
  | Etoile r -> nombre_lettres r
  | Lettre _ -> 1
  | _ -> 0;;

let lineariser r =
  let n = nombre_lettres r in
  let tab = Array.make n 'a' in
  let curr_i = ref 0 in
  let rec numeroter_regex = function
    | Union (r, g) -> Union (numeroter_regex r, numeroter_regex g)
    | Concat (r, g) -> Concat (numeroter_regex r, numeroter_regex g)
    | Etoile r -> Etoile (numeroter_regex r)
    | Lettre a -> let r = Lettre (!curr_i) in tab.(!curr_i) <- a; incr curr_i; r
    | Epsilon -> Epsilon
    | Vide -> Vide
  in (numeroter_regex r, tab) 



let vide = parse "#*|a#bc";;
let e0 = parse "(a|ba*)*|ab*a";;
let e1 = parse "a(a|b)*b";;

normaliser vide;;
normaliser e0;;
normaliser e1;;

est_vide vide;;
est_vide e0;;
est_vide e1;;

nombre_lettres vide;;
nombre_lettres e0;;
nombre_lettres e1;;

lineariser vide;;
lineariser e0;;
lineariser e1;;



module Intset = Set.Make(Int)

let rec mot_vide = function
  | Union (r, g)  -> mot_vide r || mot_vide g
  | Concat (r, g) -> mot_vide r && mot_vide g
  | Etoile _      -> true               (* étoile contient toujours ε *)
  | Epsilon       -> true
  | Vide          -> false
  | Lettre _      -> false

let rec prefixes = function
  | Union (r, g)  -> Intset.union (prefixes r) (prefixes g)
  | Concat (r, g) ->
      if mot_vide r then Intset.union (prefixes r) (prefixes g)
      else prefixes r
  | Etoile r      -> prefixes r
  | Lettre a      -> Intset.of_list [a]
  | Epsilon | Vide -> Intset.empty

let rec suffixes = function
  | Union (r, g)  -> Intset.union (suffixes r) (suffixes g)
  | Concat (r, g) ->
      if mot_vide g then Intset.union (suffixes r) (suffixes g)
      else suffixes g
  | Etoile r      -> suffixes r
  | Lettre a      -> Intset.of_list [a]
  | Epsilon | Vide -> Intset.empty

let rec facteurs n e =
  let cross aset bset =
    (* encode un couple (x,y) par x*n + y, avec n = taille de l'alphabet *)
    let lst = ref [] in
    Intset.iter (fun x ->
      Intset.iter (fun y ->
        lst := (x * n + y) :: !lst
      ) bset
    ) aset;
    Intset.of_list !lst
  in
  match e with
  | Union (r, g)  -> Intset.union (facteurs n r) (facteurs n g)
  | Concat (r, g) ->
      (* facteurs internes + facteurs traversant la jonction r|g
         (suffixes de r × prefixes de g) *)
      Intset.union
        (Intset.union (facteurs n r) (facteurs n g))
        (cross (suffixes r) (prefixes g))
  | Etoile r ->
      (* facteurs de r plus facteurs traversant la jonction entre
         deux occurrences de r (suffixes r × prefixes r) *)
      Intset.union (facteurs n r) (cross (suffixes r) (prefixes r))
  | Lettre _ | Epsilon | Vide -> Intset.empty


type 'a afnd = { finaux : bool array;
                 delta : ('a * int) list array };;

let glushkov r =
  let r', t = lineariser vide in
  let g = normaliser r' in
  let n = Array.length t in

  let p = prefixes g in
  let s = suffixes g in
  let f = facteurs g in

  let finaux = Array.make (n+1) 0 in
  Intset.iter (fun i -> finaux.(i+1) <- true) s;

  let delta = Array.make (n+1) [] in


  ;;


let vide' = normaliser (fst (lineariser vide));;
let e0' = normaliser (fst (lineariser e0));;
let e1' = normaliser (fst (lineariser e1));;

mot_vide vide';;
mot_vide e0';;
mot_vide e1';;

Intset.iter print_int (prefixes vide');;
Intset.iter print_int (prefixes e0');;
Intset.iter print_int (prefixes e1');;

Intset.iter print_int (suffixes vide');;
Intset.iter print_int (suffixes e0');;
Intset.iter print_int (suffixes e1');;

Intset.iter (fun a -> print_int a; print_char ' ') (facteurs 3 vide');;
Intset.iter (fun a -> print_int a; print_char ' ') (facteurs 6 e0');;
Intset.iter (fun a -> print_int a; print_char ' ') (facteurs 4 e1');;