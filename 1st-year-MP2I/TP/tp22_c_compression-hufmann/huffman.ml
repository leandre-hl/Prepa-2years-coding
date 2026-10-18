(* Types pour les fichiers binaires *)

type outbitfile = {
  file : out_channel;
  mutable buff : int };;

type inbitfile = {
  data : string;
  mutable pos : int };;

(* Fonctions pour les fichiers *)

let open_bit_out filename =
   { file = open_out filename; buff = 1 };;

let output_bit fd b =
  fd.buff <- fd.buff*2 + (if b then 1 else 0);
  if fd.buff >= 64 then
    begin
      output_string fd.file (String.make 1 (char_of_int (fd.buff-32)));
      fd.buff <- 1;
    end;;

let close_bit_out fd =
  while fd.buff <> 1 do output_bit fd false done;
  close_out fd.file;;

(* Fonctions pour la relecture *)

let open_bit_in filename =
  let fd = open_in filename in
  let data = input_line fd in
    close_in fd; { data = data; pos = 0 };;

let read_bit fd =
  let i = fd.pos / 6 in
  let k = int_of_char (fd.data.[i]) - 32 in
  let b = k land (1 lsl (5 - fd.pos mod 6)) <> 0 in
  fd.pos <- fd.pos + 1; b;;



(* Fonctions pour lire le contenu d'un fichier texte *)

let read_file filename = 
  let f = open_in filename in
  let txt = ref [] in
    try
      while true do txt := input_line f :: !txt done; ""
    with End_of_file -> String.concat "\n" (List.rev !txt);;

(* Encodage de Huffman *)

type tree = Leaf of int * int | Node of int * tree * tree;;



let rec print_tree t indent =
  let spaces = String.make indent ' ' in
  match t with
  | Leaf (a, b) ->
      Printf.printf "%sLeaf(%d, %d)\n" spaces a b
  | Node (v, left, right) ->
      Printf.printf "%sNode(%d)\n" spaces v;
      print_tree left (indent + 2);
      print_tree right (indent + 2);;

let char_counts str =
  let counts = Array.make 256 0 in
  for i = 0 to String.length str -1 do
    counts.(int_of_char str.[i]) <- counts.(int_of_char str.[i]) + 1
  done;
  counts

let nb_codes = function
  | Leaf (occ, _) -> occ
  | Node (occ, _, _) -> occ


let merge tr1 tr2 = Node (nb_codes tr1 + nb_codes tr2, tr1, tr2)

let rec insert tr = function
| [] -> [tr]
| h::t when nb_codes tr <= nb_codes h -> tr::h::t
| h::t -> h::insert tr t

let rec sort = function
| [] -> []
| h::t -> insert h (sort t)

let build_tree occurences =
  let list = ref [Leaf (1, 256)] in
  for i = 0 to 255 do
    if occurences.(i) <> 0
      then list := Leaf (occurences.(i), i)::!list
  done;
  let rec loop = function
    | [] -> failwith "impossible"
    | [tr] -> tr
    | h1::h2::t -> loop (insert (merge h1 h2) t)
  in sort !list |> loop;;

let tree_to_dict tr =
  let dic = Hashtbl.create 42 in
  let rec explore acc = function
  | Leaf (_, c) -> Hashtbl.add dic c (List.rev acc)
  | Node (_, lc, rc) -> (explore (false::acc) lc; explore (true::acc) rc)
  in explore [] tr;
  dic

let ratio str dico =
  let str_length = String.length str in
  let nb_bits_dico = ref 0 in
  for i = 0 to str_length -1 do
    nb_bits_dico := !nb_bits_dico + List.length (Hashtbl.find dico (int_of_char str.[i]))
  done;
  float_of_int !nb_bits_dico /. float_of_int (8 * str_length);;


let encode_char file dict c =
  let rec add_bit = function
  | [] -> ()
  | b::t -> (output_bit file b; add_bit t) 
  in add_bit (Hashtbl.find dict c)


let encode_text file dict str =
  for i = 0 to String.length str do
    encode_char file dict (int_of_char str.[i])
  done;
  encode_char file dict 256

let encode_leaf file c =
  output_bit file false;
  let rest = ref c in
  for i = 0 to 9 do
    output_bit file (!rest mod 2 = 1);
    rest := !rest / 2
  done

let rec encode_tree file = function
  | Leaf (_, c) -> encode_leaf file c
  | Node (_, lc, rc) -> encode_tree file lc; encode_tree file rc; output_bit file true


let compress str file_name =
  let file = open_bit_out file_name in
  let tr = build_tree (char_counts str) in
  let dict = tree_to_dict tr in
  encode_tree file tr;
  output_bit file true;
  encode_text file dict str;
  close_bit_out file;;

let str_file = read_file "adn.dat" in
compress str_file "adn.txt"


let read_leaf file =
  let c = ref 0 in
  for i = 0 to 9 do
    c := 2 * !c + (if read_bit file then 1 else 0)
  done;
  Leaf (0, !c)

let decode_tree file =
  let stack = Stack.create () in
  let rec explore =
    if read_bit file
      then
          let tr1 = Stack.pop stack in
          if Stack.is_empty stack
            then tr1
            else  
      else Stack.push (read_leaf file) stack

