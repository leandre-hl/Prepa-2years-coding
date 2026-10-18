type puissance4 = {grille : int array array;
                   libres : int array;
                   mutable joueur : int};;

let afficher jeu =
    let open Printf in
    let symb = [|"\x1b[34m\x1b[4m \x1b[0m"; "\x1b[31m\x1b[4m●\x1b[0m"; "\x1b[33m\x1b[4m●\x1b[0m"|] in
    print_string "\x1b[34m _ _ _ _ _ _ _\x1b[0m\n";
    for i = 0 to 5 do
       print_string "\x1b[34m|\x1b[0m";
        for j = 0 to 6 do
            printf "%s\x1b[34m|\x1b[0m" symb.(jeu.grille.(i).(j))
        done;
        print_newline ();
    done;
    print_string "\x1b[34m\x1b[1m 0 1 2 3 4 5 6\x1b[0m\n";;

let p4 = {
  grille = [| [|0; 0; 0; 0; 0; 0; 0|];
  [|0; 0; 0; 0; 0; 0; 0|];
  [|0; 0; 1; 0; 0; 0; 0|];
  [|0; 0; 2; 1; 2; 0; 0|];
  [|0; 1; 2; 2; 1; 0; 0|];
  [|2; 1; 1; 1; 2; 2; 0|] |];
  libres = [|5; 4; 2; 3; 3; 5; 6|];
  joueur = 1
};;

Random.self_init ();;

let creer_p4 () =
  {grille = Array.make_matrix 6 7 0;
  libres = Array.make 7 6;
  joueur = 1
  };;

let coup_possible p4 i = p4.libres.(i) <> 0;;

let jouer_coup p4 i =
  p4.libres.(i) <- p4.libres.(i) - 1;
  p4.grille.(p4.libres.(i)).(i) <- p4.joueur;
  p4.joueur <- 3 - p4.joueur;;

let annuler_coup p4 i =
  p4.grille.(p4.libres.(i)).(i) <- 0;
  p4.libres.(i) <- p4.libres.(i) + 1;
  p4.joueur <- 3 - p4.joueur;;

let coup_gagnant p4 i j =
  let l = p4.libres.(i) - 1 in
  let consecutifs dx dy =
    let c = ref 0 in
    let explore = ref true in
    while !c < 3 && !explore do
      let x = i + (!c+1)*dx in
      let y = l + (!c+1)*dy in
      if (x <= 6 && 0 <= x && y >= 0 && y <= 5 && p4.grille.(y).(x) = j) then
        incr c
      else
        explore := false
    done;
    !c
  in
  consecutifs (-1) 1 + consecutifs 1 (-1) >= 3
  || consecutifs 0 1 + consecutifs 0 (-1) >= 3
  || consecutifs 1 1 + consecutifs (-1) (-1) >= 3
  || consecutifs 1 0 >= 3;;

let strategie_alea p4 =
  let candidats = Array.make 7 0 in
  let nb_libres = ref 0 in 
  for i = 0 to 6 do
    if (p4.libres.(i) <> 0) then
      (candidats.(!nb_libres) <- i;
      incr nb_libres)
  done;
  if !nb_libres = 0
    then -1
    else candidats.(Random.int !nb_libres);;

let comparer strat1 strat2 =
  let p4 = creer_p4 () in
  let gagnant = ref 0 in
  let jouer = ref true in
  while !jouer do
    afficher p4;
    let i = ref 0 in
    if p4.joueur = 1
      then i := strat1 p4
      else i := strat2 p4;
    if !i = -1 
      then jouer := false
      else
        (if coup_gagnant p4 !i (p4.joueur)
          then (jouer := false; gagnant := p4.joueur);
        jouer_coup p4 !i)
  done;
  afficher p4;
  !gagnant;;

let heuristique p4 =
  let tab = [|
    [| 3; 4; 5; 7; 5; 4; 3 |];
    [| 4; 6; 8; 10; 8; 6; 4 |];
    [| 5; 8; 11; 13; 11; 8; 5 |];
    [| 5; 8; 11; 13; 11; 8; 5 |];
    [| 4; 6; 8; 10; 8; 6; 4 |];
    [| 3; 4; 5; 7; 5; 4; 3 |];
  |]
  in
  let score = ref 0 in
  for l = 0 to 5 do
    for i = 0 to 6 do
      let n = p4.grille.(l).(i) in
      score := !score + (n mod 2 - n / 2)*tab.(l).(i)
    done;
  done;
  !score;;

let rec score_coup h depth p4 =
  let sgn = if p4.joueur = 1 then 1 else -1 in
  if depth = 0 then (h p4, -1)
  else 
    let score = ref (-sgn*1001) in
    let coup = ref (-1) in
    for i = 0 downto 6 do
      if coup_possible p4 i then
        if coup_gagnant p4 i (p4.joueur) then
          (score := sgn*1000; coup := i)
        else begin
          jouer_coup p4 i;
          let (s, _) = score_coup h (depth-1) p4 in
          if (sgn*!score <= sgn*s) then
            (score := s; coup := i)
        end
    done;
  ;;

comparer strategie_alea strategie_alea;;