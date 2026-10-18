type graph = int list array


let invert gr =
  let n = Array.length gr in
  let new_gr = Array.make n [] in
  for i=0 to n-1 do
    List.iter (fun j -> new_gr.(j) <- i::new_gr.(j)) gr.(i)
  done;
  new_gr

let undirect gr =
  let n = Array.length gr in
  let dico = Hashtbl.create n in
  let new_gr = Array.make n [] in
  for i=0 to n-1 do
    List.iter (fun j ->
                if not (Hashtbl.mem dico (i,j)) then
                  begin
                    Hashtbl.add dico (j,i) ();
                    new_gr.(i) <- j::new_gr.(i);
                    new_gr.(j) <- j::new_gr.(i)
                  end) gr.(i)
  done;
  new_gr


let compl gr =
  let n = Array.length gr in
  let mat = Array.make_matrix n  in
  for i=0 to n-1 do
    List.iter (fun j-> Hashtbl.add dico (i, j) ()) gr.(i)
  done;
  for 
  let new_gr = Array.make n in
