let rec common lst1 lst2 = match lst2 with
| [] -> []
| h2::t2 -> match lst1 with
  | [] -> []
  | h1::t1 when h1 = h2 -> h1::common t1 t2
  | h1::t1 when h1 < h2 -> common t1 (h2::t2)
  | h1::t1 -> h1::common (h1::t1) t2
