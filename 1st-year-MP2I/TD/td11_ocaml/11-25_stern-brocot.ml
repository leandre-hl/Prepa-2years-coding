type stern_brocot_tree =
| Nil
| N of stern_brocot_tree * int * int * stern_brocot_tree

let get_fracs h =
  let n = 1 lsl (h+1) + 1 in
  let fracs = Array.make n (0,0) in
  fracs.(0) <- (0,1);
  fracs.(n-1) <- (1,0);
  let rec build_middle i j =
    if i < j - 1 then
      begin
        let m = (j+i)/2 in
        let u ,v  = fracs.(i)
        and u',v' = fracs.(j) in
        fracs.(m) <- (u+u'),(v+v');
        build_middle i m;
        build_middle m j;
      end
  in build_middle 0 (n-1);
  fracs

let stern_brocot_tree h =
  let fracs = get_fracs h in
  let rec build i j =
    if i > j then Nil
    else
      begin
        let m = (j+i+1)/2 in
        let u, v = fracs.(m) in
        N (build i (m-1), u, v, build (m+1) j)
      end
  in build 1 (1 lsl (h+1) - 1)