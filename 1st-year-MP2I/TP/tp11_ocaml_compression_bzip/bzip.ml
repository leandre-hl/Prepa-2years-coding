let read filename = 
  (* On ouvre le fichier en mode binaire *)
  let ic = open_in_bin filename in
  (* On determine sa longueur *)
  let length = in_channel_length ic in
  (* On lit une chaine de la longueur correspondante *)
  really_input_string ic length

let to_array s =
  Array.init (String.length s) (fun i -> int_of_char s.[i])

let to_string t =
  String.init (Array.length t) (fun i -> char_of_int t.(i))

let print_int_array arr =
  let n = Array.length arr in
  print_string "[|";
  for i = 0 to n - 1 do
    Printf.printf "%d" arr.(i);
    if i < n - 1 then print_string "; "
  done;
  print_endline "|]"
(*
let tri_rotations t = (* definir compare_rotations avant *)
  let n = Array.length t in
  let ordre = Array.make n 0 in
  for i = 1 to n-1 do ordre.(i) <- i done;
  Array.sort (compare_rotations t) ordre;
  ordre;;
*)
let data = to_array (read ("/home/leandrehl/ocaml/tp_info/tp11/ocaml.ppm"))

let frequencies arr =
  let n = Array.length arr in
  let freq = Array.make 256 0 in
  for i=0 to n-1 do
    freq.(arr.(i)) <- freq.(arr.(i)) + 1
  done;
  freq

let less_frequent arr =
  let freq = frequencies arr in
  let min = ref 0 in
  for i=1 to 255 do
    if freq.(i) < freq.(!min) then
      min := i
  done;
  !min

let count_repeats arr i =
  let n = Array.length arr in
  let count = ref 1 in
  let j = ref (i+1) in
  while !j < n && arr.(!j) = arr.(i) && !count <= 255 do begin
    incr count;
    incr j
    end
  done;
  !count

let size_encoded arr =
  let n = Array.length arr in
  let k = less_frequent arr in
  let i = ref 0 in
  let size = ref 1 in
  while !i < n do begin
    let n = count_repeats arr !i in begin
    match n with
    | 1 when arr.(!i) = k -> size := !size + 2
    | n when n <= 2 -> size := !size + n
    | n -> size := !size + 3 * n/255 + 3
    end;
    i := !i + n
  end
  done;
  !size

let _ = print_int (size_encoded data)
