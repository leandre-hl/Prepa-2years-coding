type rationnal = {n: int; d: int}

let r_prod r1 r2 = {n = r1.n * r2.n; d = r2.d * r2.d}

let r_inv = function
| {n=0; _} -> failwith "Div par 0"
| {n=m; d=e} -> {n = e; d = m}
