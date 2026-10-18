type graph = int list array


let build_euler gr =
  let htbl = Hashtbl.create 42 in
  let copy = Array.copy gr in
  let rec explore i = match copy.(i) with
    | [] -> [0]
    | 0::h::t -> (copy.(i) <- h::t @ [0]; explore i)
    | h::t -> (copy.(i) <- t; if Hashtbl.mem htbl (i, h)
        then explore i
        else (Hashtbl.add htbl (h,i) true; i::explore h)
      )
  in explore 0


let test = [|[1;2];[0;2];[0;1;3;4];[2;4];[2;3]|];;