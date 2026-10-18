module IntSet = Set.Make(Int)

type formule =
  | Top
  | Bot
  | Var of int
  | Neg of formule
  | Impl of formule * formule
  | Et of formule * formule
  | Ou of formule * formule


type valuation = bool array

let rec interpretation mu = function
  | Top -> true
  | Bot -> false
  | Var i -> mu.(i)
  | Neg b -> not (interpretation mu b)
  | Impl (b,c) -> not (interpretation mu b) || interpretation mu c
  | Et (b,c) -> interpretation mu b && interpretation mu c
  | Ou (b,c) -> interpretation mu b || interpretation mu c

let rec nombre_variables = function
  | Top -> 0
  | Bot -> 0
  | Var i -> i + 1
  | Neg b -> nombre_variables b
  | Impl (b,c)| Et (b,c)|Ou (b, c) -> max (nombre_variables b) (nombre_variables c)

let tautologie a =
  let n = nombre_variables a in
  let mu = Array.make n false in
  let rec explore i =
    if i = n
      then
        interpretation mu a
      else
        if explore (i+1) 
          then begin
            mu.(i) <- true;
            if explore (i+1)
              then (mu.(i) <- false; true)
              else false
          end else false
  in explore 0

type sequent = {
  gamma : formule list;
  g_var : IntSet.t;
  delta : formule list;
  d_var : IntSet.t
}

let creer_sequent gamma delta =
  {gamma = gamma; g_var = IntSet.empty; delta = delta; d_var = IntSet.empty}


let rec valide seq =
  let gamma = ref seq.gamma in
  IntSet.iter (fun i -> gamma := Var i :: !gamma) seq.g_var;
  let inter_gamma = List.fold_left (fun a b -> Et (a, b)) Top !gamma in

  let delta = ref seq.delta in
  IntSet.iter (fun i -> delta := Var i :: !delta) seq.d_var;
  let union_delta = List.fold_left (fun a b -> Ou (a, b)) Bot !delta in

  tautologie (Impl (inter_gamma, union_delta))

let impl_droite seq = match seq.delta with
  | Impl (a, b) :: q ->
    {gamma = a :: seq.gamma; g_var = seq.g_var;
    delta = b :: q; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let impl_gauche seq = match seq.gamma with
  | Impl (a, b) :: q ->
    {gamma = q; g_var = seq.g_var; delta = a :: seq.delta; d_var = seq.d_var},
    {gamma = b :: q; g_var = seq.g_var; delta = seq.delta; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let et_gauche seq = match seq.gamma with
  | Et (a, b) :: q ->
    {gamma = a :: b :: q; g_var = seq.g_var;
    delta = seq.delta; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let et_droite seq = match seq.delta with
  | Et (a, b) :: q ->
    {gamma = seq.gamma; g_var = seq.g_var; delta = a :: q; d_var = seq.d_var},
    {gamma = seq.gamma; g_var = seq.g_var; delta = b :: q; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let ou_gauche seq = match seq.gamma with
  | Ou (a, b) :: q ->
    {gamma = a :: q; g_var = seq.g_var; delta = seq.delta; d_var = seq.d_var},
    {gamma = b :: q; g_var = seq.g_var; delta = seq.delta; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let ou_droite seq = match seq.delta with
  | Ou (a, b) :: q ->
    {gamma = seq.gamma; g_var = seq.g_var;
    delta = a :: b :: q; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let neg_gauche seq = match seq.gamma with
  | Neg a :: q ->
    {gamma = q; g_var = seq.g_var;
    delta = a :: seq.delta; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let neg_droite seq = match seq.delta with
  | Neg a :: q ->
    {gamma = a :: seq.gamma; g_var = seq.g_var;
    delta = q; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let aff_gauche seq = match seq.gamma with
  | a :: q ->
    {gamma = q; g_var = seq.g_var;
    delta = seq.delta; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"
let aff_droite seq = match seq.delta with
  | a :: q ->
    {gamma = seq.gamma; g_var = seq.g_var;
    delta = q; d_var = seq.d_var}
  | _ -> failwith "Erreur règle"

let rec prouvable seq =
  match seq.gamma with
    | Bot :: _ -> true
    | Top :: _  -> prouvable (aff_gauche seq)
    | Var i :: q -> prouvable {gamma = q; delta = seq.delta; g_var = IntSet.add i seq.g_var; d_var = seq.d_var}
    | Impl _ :: _ -> let a, b = impl_gauche seq in prouvable a && prouvable b
    | Et _ :: _ -> prouvable (et_gauche seq)
    | Ou _ :: _ -> let a, b = ou_gauche seq in prouvable a && prouvable b
    | Neg _ :: _ -> prouvable (neg_gauche seq)
    | [] -> begin
              match seq.delta with
                | Bot :: _ -> prouvable (aff_droite seq)
                | Top :: _ -> true
                | Var i :: q -> prouvable {gamma = seq.gamma; delta = q; g_var = seq.g_var; d_var = IntSet.add i seq.d_var}
                | Impl _ :: _ -> prouvable (impl_droite seq)
                | Et _ :: _ -> let a, b = et_droite seq in prouvable a && prouvable b
                | Ou _ :: _ -> prouvable (ou_droite seq)
                | Neg _ :: _ -> prouvable (neg_droite seq)
                | [] -> not (IntSet.is_empty (IntSet.inter seq.g_var seq.d_var))
            end

let s1 = creer_sequent [] [Ou (Var 1,Neg (Var 1))];;
let s2 = creer_sequent [Et (Var 1, Neg (Var 1))] [];;
let s3 = creer_sequent [Ou (Neg (Var 1), Neg (Var 2))] [Neg (Et (Var 1,Var 2))];;
let s4 = creer_sequent [Neg (Et (Var 1, Var 2))] [Ou (Neg (Var 1), Neg (Var 2))];;
let s5 = creer_sequent [] [Impl (Impl (Impl (Var 1, Var 2), Var 1), Var 1)];;

prouvable s1;;
prouvable s2;;
prouvable s3;;
prouvable s4;;
prouvable s5;;