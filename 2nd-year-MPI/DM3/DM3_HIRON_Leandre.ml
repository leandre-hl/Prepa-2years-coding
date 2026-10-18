type graphe = (int * int) list array
(** Graphe non orienté : chaque sommet i est associé à une liste de couples (voisin, poids) *)

(**********************************************************************)
(* ALGORITHMES DE BASE                                                *)
(**********************************************************************)

let rec partition piv = function
  | [] -> [], []
  | h::t ->
    let inf_lst, sup_lst = partition piv t in
    if h <= piv
    then h::inf_lst, sup_lst
    else inf_lst, h::sup_lst

let rec tri_rapide = function
  | [] -> []
  | piv::r ->
    let left, right = partition piv r in
    (tri_rapide left) @ piv :: (tri_rapide right)
(** Tri rapide récursif — attention : non optimisé (concaténations coûteuses en O(n²)) *)

(**********************************************************************)
(* CONSTRUCTION ET MESURE DE GRAPHES                                  *)
(**********************************************************************)

let construire_graphe nom_fichier =
  let f = open_in nom_fichier in
  let n = int_of_string (input_line f) in
  let g = Array.make n [] in
  try
    while true do
      let l = input_line f in
      match List.map int_of_string (String.split_on_char ' ' l) with
      | [s; t; p] ->
        g.(s) <- (t, p)::g.(s);
        g.(t) <- (s, p)::g.(t)
      | _ -> failwith "format de fichier invalide"
    done;
    g
  with End_of_file -> g
(** Lecture jusqu’à la fin du fichier.  
    Les arêtes sont ajoutées dans les deux sens, car le graphe est non orienté. *)

let poids_graphe g =
  Array.fold_left (+) 0
    (Array.map (fun l -> List.fold_left (+) 0 (List.map snd l)) g) / 2
(** On divise par 2 car chaque arête est comptée deux fois (une par extrémité). *)

(**********************************************************************)
(* UNION-FIND                                                         *)
(**********************************************************************)

let creer_partition n = 
  Array.make n (-1)
(** Les éléments négatifs indiquent que l'indice est une racine et que la valeur stocke le rang. *)

let rec trouver partition x =
  if partition.(x) < 0 then x
  else
    let z = trouver partition partition.(x) in
    partition.(x) <- z;  (* Compression de chemin *)
    z

let unir partition x y =
  let zx = trouver partition x in
  let zy = trouver partition y in
  if zx <> zy then
    let rx = -1 - partition.(zx) in
    let ry = -1 - partition.(zy) in
    if rx < ry then
      partition.(zx) <- zy
    else begin
      partition.(zy) <- zx;
      if rx = ry then
        partition.(zx) <- -1 - (rx+1)
    end
(** Union par rang : on attache l’arbre le plus petit sous le plus grand.  
    La valeur négative encode le rang de la racine. *)

(**********************************************************************)
(* ALGORITHME DE KRUSKAL                                              *)
(**********************************************************************)

let aretes g =
  let rec triplets_fst s = function
    | [] -> []
    | (t,f)::rest when s<t -> (f, s, t)::triplets_fst s rest
    | _::rest -> triplets_fst s rest
  in
  Array.to_list g
  |> List.mapi triplets_fst
  |> List.flatten
  |> tri_rapide
(** On génère les arêtes (poids, s, t) avec s < t pour éviter les doublons,
    puis on les trie par poids. *)

let kruskal g =
  let n = Array.length g in
  let arbre = Array.make n [] in
  let partition = creer_partition n in
  let traite_arrete (f,s,t) =
    if trouver partition s <> trouver partition t then begin
      unir partition s t;
      arbre.(s) <- (t, f)::arbre.(s);
      arbre.(t) <- (s, f)::arbre.(t)
    end
  in
  List.iter traite_arrete (aretes g);
  arbre
(** Implémentation standard de Kruskal :  
    - on parcourt les arêtes triées,  
    - on n’ajoute l’arête que si elle relie deux composantes distinctes.  
    L’union-find garantit que l’arbre reste acyclique. *)

(**********************************************************************)
(* SECTION DE TESTS                                                   *)
(**********************************************************************)

(* Utilitaires pour les tests *)
let liste_aleatoire n a b = 
  List.init n (fun _ -> a + Random.int (b - a))

(* Tests de partition et tri *)
let test_partition () =
  assert (partition 3 [4;2;1;-1;5;6] = ([2;1;-1], [4;5;6]));
  assert (partition 3 [] = ([], []));
  assert (partition 10 [4;3;3] = ([4;3;3], []));
  Printf.printf "partition ok\n"

let test_tri_rapide () =
  for i = 0 to 20 do
    let l = liste_aleatoire (50*i) (-i) i in
    assert (tri_rapide l = List.sort compare l)
  done;
  Printf.printf "tri rapide ok\n"

(* Tests poids_graphe *)
let test_poids_graphe () =
  let g = Array.make 3 [] in
  g.(0) <- [(1,1); (2,2)];
  g.(1) <- [(0,1); (2,3)];
  g.(2) <- [(0,2); (1,3)];
  assert (poids_graphe g = 1+2+3);
  Printf.printf "poids_graphe (manuel) ok\n";

  let g_10_ad = construire_graphe "g_10_ad.txt" in
  assert (poids_graphe g_10_ad = 168);
  let g_10_sd = construire_graphe "g_10_sd.txt" in
  assert (poids_graphe g_10_sd = 343);
  Printf.printf "poids_graphe (fichiers) ok\n"

(* Tests union-find *)
let test_union_find () =
  let p = creer_partition 6 in
  assert (trouver p 0 = 0);
  unir p 0 1;
  unir p 2 3;
  unir p 0 2;
  assert (trouver p 1 = trouver p 3);
  assert (trouver p 0 = trouver p 1);

  let q = creer_partition 10 in
  unir q 0 1; unir q 0 2; unir q 3 2; unir q 4 5;
  unir q 7 8; unir q 7 4; unir q 6 9; unir q 6 4; unir q 0 7; unir q 9 1;
  assert (q = [|7; 7; 0; 0; 7; 4; 7; -3; 7; 7|]);
  Printf.printf "union-find ok\n"

(* Tests extraction d'arêtes *)
let test_aretes () =
  let g = Array.make 4 [] in
  g.(0) <- [(1,5); (2,3)];
  g.(1) <- [(0,5); (2,1)];
  g.(2) <- [(0,3); (1,1); (3,7)];
  g.(3) <- [(2,7)];
  let lst = aretes g in
  assert (List.length lst = 4);
  assert (List.map (fun (p,_,_) -> p) lst = [1;3;5;7]);
  Printf.printf "aretes ok\n"

(* Tests Kruskal simples et fichiers *)
let test_kruskal_simple () =
  let g = Array.make 3 [] in
  g.(0) <- [(1,1); (2,3)];
  g.(1) <- [(0,1); (2,2)];
  g.(2) <- [(0,3); (1,2)];
  let mst = kruskal g in
  assert (poids_graphe mst = 3);
  Printf.printf "kruskal (manuel) ok\n"

let test_kruskal_fichiers () =
  let kruskal_10_ad = kruskal (construire_graphe "g_10_ad.txt") in
  assert (poids_graphe kruskal_10_ad = 66);
  let kruskal_10_sd = kruskal (construire_graphe "g_10_sd.txt") in
  assert (poids_graphe kruskal_10_sd = 117);
  Printf.printf "kruskal (fichiers) ok\n"

(* Cas dégénérés *)
let test_degeneres () =
  let g0 = [||] in
  assert (poids_graphe g0 = 0);
  let g1 = Array.make 1 [] in
  assert (poids_graphe g1 = 0);
  let mst1 = kruskal g1 in
  assert (poids_graphe mst1 = 0);
  Printf.printf "cas dégénérés ok\n"

(**********************************************************************)
(* EXÉCUTION DES TESTS                                                *)
(**********************************************************************)

let run_tests () =
  Printf.printf "=== Début des tests ===\n";
  test_partition ();
  test_tri_rapide ();
  test_poids_graphe ();
  test_union_find ();
  test_aretes ();
  test_kruskal_simple ();
  test_kruskal_fichiers ();
  test_degeneres ();
  Printf.printf "=== Tous les tests sont validés ===\n"

let _ =
  Random.self_init ();
  run_tests ();
  let g_1000_sd = construire_graphe "g_1000_sd.txt" in
  Printf.printf "Poids g_1000_sd : %d\n" (poids_graphe g_1000_sd);
  let mst = kruskal g_1000_sd in
  Printf.printf "Poids ACM : %d\n" (poids_graphe mst);
  let g_1000_ad = construire_graphe "g_1000_ad.txt" in
  Printf.printf "Poids g_1000_ad : %d\n" (poids_graphe g_1000_ad);
  let mst = kruskal g_1000_ad in
  Printf.printf "Poids ACM : %d\n" (poids_graphe mst);
