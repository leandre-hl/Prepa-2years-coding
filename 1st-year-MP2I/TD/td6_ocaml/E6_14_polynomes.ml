type monomial = float * int
type polynomial = monomial list

let rec p_eval x (p:polynomial) = match p with
  | [] -> 0.
  | (coef, exp)::t -> coef *. (x ** (float_of_int exp)) +. (p_eval x t)

let rec p_sum (p1:polynomial) (p2:polynomial) = match p1, p2 with
| [], _ -> p2
| _, [] -> p1
| (c1, e1)::t1, (c2, e2)::t2 ->
  if e1 = e2 then 
    (c1 +. c2, e1)::p_sum t1 t2
  else if e1 < e2 then
    (c1 , e1)::p_sum t1 ((c2, e2)::t2)
  else
    (c2 , e2)::p_sum ((c1, e1)::t1) t2

let rec m_mult (m:monomial) (p:polynomial) = match p with
  | [] -> []
  | (coef, exp)::t -> (coef *. (fst m), exp + (snd m))::m_mult m t

let rec p_mult (p1:polynomial) (p2:polynomial) = match p1 with
| [] -> []
| m::t -> p_sum (m_mult m p2) (p_mult t p2)