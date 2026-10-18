(* Affichage d'une grille *)

let draw arr =
  let nbl = Array.length arr
  and nbc = Array.length arr.(0) in
  let draw_line () =
    print_string "+";
    print_string (String.make nbc '-');
    print_string "+\n" in
  draw_line ();
  for i = 0 to nbl - 1 do
    print_string "|"; 
    Array.iter
      (fun i -> print_char (match i with 0 -> ' ' | 1 -> 'X' | _ -> '?')) arr.(i);
    print_string "|\n"; 
  done;
  draw_line ()

(* Extraction et insertion d'une ligne/colonne *)

let get_line i arr =
  let n = Array.length arr.(i) in
  let res = Array.make n 0 in
    for j = 0 to n-1 do res.(j) <- arr.(i).(j) done;
    res

let get_col j arr =
  let n = Array.length arr in
  let res = Array.make n 0 in
    for i = 0 to n-1 do res.(i) <- arr.(i).(j) done;
    res

let set_line i line arr =
  for j = 0 to (Array.length line - 1) do
    arr.(i).(j) <- line.(j)
  done

let set_col j col arr =
  for i = 0 to (Array.length col - 1) do
    arr.(i).(j) <- col.(i)
  done

(* Cr�ation d'une grille vide *)

let init_grid (clue_l, clue_c) =
  Array.make_matrix (List.length clue_l) (List.length clue_c) (-1)

(* Pour la r�solution de grilles difficiles *)

exception Impossible

let copy_grid arr = Array.map Array.copy arr

(* Puzzles *)

let puzzle1 = ( [ [1;2]; [2]; [1]; [1]; [2]; [2;4]; [2;6]; [8]; [1;1];
                  [2;2] ],
                [ [2]; [3]; [1]; [2;1]; [5]; [4]; [1;4;1]; [1;5]; [2;2];
                  [2;1] ] );;

let puzzle2 = ( [ [5]; [9]; [2;1;1;1;2]; [1;1;1;1;1]; [11]; [1]; [1]; 
                  [1]; [1]; [1;1]; [3] ],
                [ [3]; [2;1]; [1;2]; [3;1]; [2;1]; [11]; [2;1;1];
                  [3;1;2]; [1;2]; [2;1]; [3] ] );;

let puzzle3 = ( [ [1]; [1]; [2;2]; [1;5]; [8]; [6]; [2;3] ],
                [ [2]; [1;1;1]; [7]; [3]; [5]; [5]; [4]; [2] ] );;

let puzzle4 = ( [ [1;1]; [3]; [3]; [4]; [6]; [5]; [1;1;3]; [6] ],
                [ [3;1]; [4;1]; [8]; [3;1]; [5]; [4]; [4] ] );;

let puzzle5 = ( [ [3]; [1;1]; [1;1;1]; [2;1]; [1;5]; [1;1;1];
                  [1;3;1]; [2;2]; [7]; [1;1] ],
                [ [1]; [7]; [1;2]; [1;1;1]; [1;2]; [4;1;1];
                  [1;1;2]; [3;1]; [1;2]; [4] ] );;

let puzzle6 = ( [ [5]; [1;5]; [3;1]; [2;2]; [3;3]; [5;4]; [2;4;2]; 
                  [1;1;2]; [1;4;1]; [4;7]; [4;2;2]; [2;2;2;1]; 
                  [1;1;1;1]; [1;1;1;1]; [1;1;1] ],
                [ [1;3]; [2;2;1]; [1;5]; [3;2]; [1;4]; [1;1;3;3]; 
                  [1;1;1;1]; [1;2;2]; [1;1;1;3]; [1;1;1;3;1]; 
                  [3;2;2]; [5;1]; [1;7]; [2;4;2;1]; [1;3] ] );;

let puzzle7 = ( [ [2]; [1;2]; [1;1]; [2]; [1]; [3]; [3]; [2;2]; 
                  [2;1]; [2;2;1]; [2;3]; [2;2] ],
                [ [2;1]; [1;3]; [2;4]; [3;4]; [4]; [3]; [3]; [3]; 
                  [2]; [2] ] );;

let puzzle8 = ( [ [2]; [2]; [2]; [2]; [1] ],
                [ [2]; [2]; [2]; [2]; [1] ] );;

let puzzle9 = ( [ [0]; [2;3]; [1;1;1]; [1;1;4]; [8;1]; [5;2;2]; 
                  [1;2;2;1]; [2;1;1;1;1;1]; [1;1;5]; [1;1;1;1;3]; 
                  [4;2;2;1;1]; [3;2;2;1]; [1;2;2;3]; [2;4;1]; 
                  [3;1;2;2;1]; [1;1;3;2]; [2;1;2]; [6]; [1;1;2]; 
                  [2;2;1]; [2;4]; [2]; [1]; [2]; [1] ],
                [ [2]; [1]; [1]; [1]; [2]; [2]; [3;1]; [4;1;1;1]; 
                  [3;1;2;1]; [1;4;2]; [7;1;1]; [5;2;2;1]; 
                  [1;2;2;1;5]; [1;1;1;1;5;2]; [1;1;1;2;1;1]; 
                  [1;1;1;1;1;1]; [1;1;1;2;2]; [5;2;1;2]; [3;2;1]; 
                  [1;6;1]; [1;2;2]; [1;2;1]; [3;1;3]; [1;1]; [2] ] )
                  
;;

(* Fin du pr�ambule *)


let rec list_sols n s = match n, s with
	| 0, 0 -> [[]]
	| 0, s -> [[]]
	| 1, s -> [[s]]
	| n, s -> List.flatten (List.init (s+1) (fun i -> List.map (fun x -> i::x) (list_sols (n-1) (s-i))));;

list_sols 3 3;;

		
let white_blocks ind n =
	let check_valid = function
	| [] -> true
	| _::t ->
		let rec aux = function
			| [0] -> true
			| [] -> true
			| 0::_ -> false
			| _::t -> aux t
		in aux t in
	let s = List.fold_left (+) 0 ind in
	let nb = List.length ind in
	List.filter check_valid (list_sols (nb+1) (n-s));;

white_blocks [3;2] 8;;

let build whites blacks =
	let init n k = List.init n (fun i -> k) in
	let rec list_build = function
	| [w], [] -> init w 0
	| w::wt, b::bt -> init w 0 @ init b 1 @ list_build (wt,bt)
	| _ -> failwith "Entry does not match requirements"
	in Array.of_list (list_build (whites, blacks));;

build [1;2;0] [3;2];;

let solutions ind n =
	List.map (fun x -> build x ind) (white_blocks ind n);;
	
solutions [3;2] 8;;

let result ind n =
	let sols = solutions ind n in
	let res = Array.copy (List.hd sols) in
	let concat a =
		for i = 0 to n-1 do
			if res.(i) <> a.(i) then res.(i) <- -1
		done
	in List.iter concat sols;
	res;;
	
result [3;2] 8;;


exception Bug;;
let result_with_data ind infos =
	let n = Array.length infos in
	let sols = solutions ind n in
	let res = Array.copy (List.hd sols) in
	let check_valid sol =
		try
			for i = 0 to n-1 do
				if infos.(i) <> -1 && infos.(i) <> sol.(i)
					then raise Bug
			done;
			true
		with
		| Bug -> false in
	let concat a =
		for i = 0 to n-1 do
			if res.(i) <> a.(i) then res.(i) <- -1
		done
	in match List.filter check_valid sols with
	| [] -> failwith "no solution !"
	| lst ->	List.iter concat lst;
	res;;
	
result_with_data [3;2] [|0;-1;-1;-1;-1;-1;-1;1|];;
