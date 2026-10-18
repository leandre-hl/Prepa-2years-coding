(********************************************************************)
(* Concours Centrale-Supélec                                        *)
(* Sujet 0 - MPI                                                    *)
(* https://www.concours-centrale-supelec.fr                         *)
(* CC BY-NC-SA 3.0                                                  *)
(********************************************************************)

let texte_preface = "préfacedanslaquelleilestétablique,malgréleursnomsenosetenis,leshérosdel'histoirequenousallonsavoirl'honneurderaconteranoslecteursn'ontriendemythologique."

type lexique = (string, int) Hashtbl.t

(* Lexique correspondant à l'exemple proposé dans le sujet *)
let dico_ex : lexique =
  let h = Hashtbl.create 4 in
  let add (m, c) = Hashtbl.add h m c in
  List.iter add [("a", 1); ("ab", 1); ("aba", 2); ("bb", 1)];
  h

(* Vérifie qu'un fichier de lexique est conforme au format demandé *)
let verifie_format nom_fichier =
  let f = open_in nom_fichier in
  begin
    try
      while true do
        match String.split_on_char ' ' (input_line f) with
        | [mot; occ] ->
           assert (String.length mot <= 100);
           assert (int_of_string occ >= 1);
        | _ -> failwith "Erreur de format"
      done
    with End_of_file -> close_in f
  end


let _ = verifie_format "data/les_trois_mousquetaires.lex"


let file_to_lexique nom_fichier =
  let f = open_in nom_fichier in
  let lex = Hashtbl.create 42 in
  begin
    try
      while true do
        match String.split_on_char ' ' (input_line f) with
        | [mot; occ] ->
           Hashtbl.replace lex mot (int_of_string occ)
        | _ -> failwith "Erreur de format"
      done
    with End_of_file -> close_in f
  end;
  lex


let lex = file_to_lexique "data/les_miserables.lex"
let max_len = ref 0
let count = ref 0
let _ = Printf.printf "Nb de mots : %d\n" (Hashtbl.length lex);
  Hashtbl.iter (fun m _ -> max_len := max !max_len (String.length m)) lex;
  Printf.printf "Longueur max : %d\n" !max_len;
  Hashtbl.iter (fun m i -> if i=1 then incr count) lex;
  Printf.printf "Nb mots à une occurence : %d\n" !count

let est_mot = Hashtbl.mem

let score lex mot =
  match Hashtbl.find_opt lex mot with
  | Some occ -> log occ
  | None -> neg_infinity

let rec segmentation lex t =
  let n = String.length t in
  if n=0 then Some ([])
  else
    let rec explore i =
      if i > !max_len || i >= n then None
      else begin
        let mot = String.sub t 0 (i + 1) in
        if est_mot lex mot then
          match segmentation lex (String.sub t (i + 1) (n - i - 1)) with
          | None -> explore (i + 1)
          | Some seg_lst -> Some (mot :: seg_lst)
        else None
      end in
    explore 0;;
  
segmentation dico_ex "abab";;


let rec segmentation_denom lex t =
  let n = String.length t in
  if n=0 then 1
  else
    let sum = ref 0 in
    for i = 0 to (min !max_len n) - 1 do
      let mot = String.sub t 0 (i + 1) in
      if est_mot lex mot then
        sum := !sum + segmentation_denom lex (String.sub t (i + 1) (n - i - 1))
      else ()
    done;
    !sum;;

segmentation_denom lex "laquelleestlameilleure"


let segmentation_denom_memo lex t =
  let n = String.length t in
  let memo = Array.make n (-1) in
  let rec aux start =
    if start = n then 1
    else if memo.(start) != -1 then memo.(start)
    else begin
      memo.(start) <- 0;
      for i = 0 to (min !max_len (n-start)) - 1 do
        let mot = String.sub t start (i + 1) in
        if est_mot lex mot then
          memo.(start) <- memo.(start) + aux (start + i + 1)
        else ()
      done;
      memo.(start)
    end in
  aux 0;;


segmentation_denom_memo lex texte_preface mod 1000000;;



let meilleure_segmentation_memo lex t =
  let n = String.length t in
  let memo = Array.make n None in
  let rec aux start =
    if start = n then []
    else
      match memo.(start) with 
      | Some v -> v
      | None -> else begin
          let best_mot = ref "" in
          let best_score_mot = ref (-1) in
          for i = 0 to (min !max_len (n-start)) - 1 do
            let mot = String.sub t start (i + 1) in
            if est_mot lex mot then
              memo.(start) <- memo.(start) + aux (start + i + 1)
            else ()
          done;
          memo.(start)
  aux 0;;
  