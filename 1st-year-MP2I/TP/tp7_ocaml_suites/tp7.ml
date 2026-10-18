type 'a suite = {u0: 'a; f: 'a -> 'a}

let f_syracuse un = match un mod 2 with
| 0 -> un/2
| _ -> 3*un + 1

let rec nth u = function
| 0 -> u.u0
| n -> u.f (nth u (n-1))

let _ = nth {u0 = 1023; f = f_syracuse} 41

let rec premiers u = function
| 0 -> [u.u0]
| n -> u.u0::premiers {u0 = u.f u.u0; f = f_syracuse} (n-1)

let _ = premiers {u0 = 1023; f = f_syracuse} 70

let rec index el = function
| [] -> -1
| h::_ when h = el -> 0
| _::t -> match index el t with
      | -1 -> -1
      | n -> 1 + n 
          
let _ = index 1 (premiers {u0 = 1023; f = f_syracuse} 70)

let periode lst =
  let rec periode_rec = function
    | ([], _) -> failwith "pas de periode"
    | (h::t, k) -> match index h t with
      | -1 -> periode_rec (t, k+1)
      | n -> (k, n+1)
  in periode_rec (lst, 0)

let _ = periode (premiers {u0 = 1023; f = f_syracuse} 70);;

let floyd u = 
  let rec floyd_rec u vi ui i = 
    let vi_nxt = u.f (u.f vi) in
    let ui_nxt = u.f ui in
    if vi_nxt = ui_nxt then
      i
    else
      floyd_rec u vi_nxt ui_nxt (i+1)
  in floyd_rec u u.u0 u.u0 1

let _ = floyd {u0 = 1023; f = f_syracuse}

let _ = floyd {u0 = nth {u0 = 1023; f = f_syracuse} (floyd {u0 = 1023; f = f_syracuse}); f = f_syracuse}

let min_periode u = floyd {u0 = nth u (floyd u); f = u.f}

