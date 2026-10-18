let est_vide = function
| [] -> true
| _ -> false

let rec union lst1 lst2 = match lst2 with
| [] -> lst1
| h::t when List.mem h lst1 -> union lst1 t
| h::t -> union (h::lst1) t

let rec inter lst1 lst2 = match lst2 with
| [] -> []
| h::t when List.mem h lst1 -> h::inter lst1 t
| h::t -> inter lst1 t

let rec diff lst1 lst2 = match lst1 with
| [] -> []
| h::t when List.mem h lst2 -> diff t lst2
| h::t -> h::diff t lst2

let disj lst1 lst2 = match inter lst1 lst2 with
| [] -> true
| _ -> false

let inclus lst1 lst2 = (union lst2 lst1 = lst2)

let egaux lst1 lst2 = inclus lst1 lst2 && inclus lst2 lst1

type partie = Finie of int list | Cofinie of int list

let est_vide_W prt = prt = Finie []

let compl_W = function
| Finie lst -> Cofinie lst
| Cofinie lst -> Finie lst

let union_W prt1 prt2 = match prt1, prt2 with
| Finie lst1, Finie lst2 -> Finie (union lst1 lst2)
| Cofinie lst1, Cofinie lst2 -> Cofinie (inter lst1 lst2)
| Finie lst1, Cofinie lst2 -> Cofinie (diff lst2 lst1)
| Cofinie lst1, Finie lst2 -> Cofinie (diff lst1 lst2)

let inter_W prt1 prt2 = match prt1, prt2 with
| Finie lst1, Finie lst2 -> Finie (inter lst1 lst2)
| Cofinie lst1, Cofinie lst2 -> Cofinie (union lst1 lst2)
| Finie lst1, Cofinie lst2 -> Cofinie (diff lst1 lst2)
| Cofinie lst1, Finie lst2 -> Cofinie (diff lst2 lst1)

let disj_W prt1 prt2 = est_vide_W (inter_W prt1 prt2)

let inclus_W prt1 prt2 = union_W (prt2 prt1) = prt2

let egaux_W prt1 prt2 = inclus prt1 prt2 && inclus prt2 prt1

let complementaires_W prt1 prt2 = est_vide_W (inter_W prt1 prt2) && est_vide_W (compl_W (union_W prt1 prt2))

let union_U f1 f2 = (fun x -> f1(x) || f2(x))

let inter_U f1 f2 = (fun x -> f1(x) && f2(x))

let diff_U f1 f2 = (fun x -> f1(x) && !f2(x))

let compl_U f1 = (fun x -> not (f1 x))

let convert lst = (fun x -> List.mem x lst)

let convert_W = function
| Finie lst -> convert lst
| Cofinie lst -> compl_U (convert lst)


(* Skip partie 1.5*)


type pint = Zero | S of pint

let print_pint pint =
  let rec aux = function
    | Zero -> 0
    | S a -> 1 + (aux a)
  in print_int (aux pint) ; print_newline ()


