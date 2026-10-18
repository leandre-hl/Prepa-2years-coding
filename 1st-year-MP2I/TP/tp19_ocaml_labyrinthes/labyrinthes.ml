(* A copier coller dans WinCaml*)

(* OCaml r�cent *)
(* 
#use "topfind";;
#require "graphics";;
*)

(* WinCaml *)
#load "graphics.cma";;


(*-------------------------------------------------*)

open Graphics;;

(*-------------------------------------------------*)
(* Module Graph pour un graphe non-oriente         *)

module Graph : sig
  (* Type abstrait *)
  type 'a t
  (* Cr�ation d'un graphe vide *)
  val create : unit -> 'a t
  (* Ajout d'une ar�te (v_i, v_j) *)
  val add_edge : 'a t -> 'a -> 'a -> unit
  (* Suppression d'une ar�te (v_i, v_j) *)
  val del_edge : 'a t -> 'a -> 'a -> unit
  (* Liste des voisins de v_i *)
  val neighbors : 'a t -> 'a -> 'a list
  (* D�termine si deux sommets v_i et v_j sont voisins *)
  val exists_edge : 'a t -> 'a -> 'a -> bool
end = struct
  type 'a t = ('a,'a list) Hashtbl.t
  let create () = Hashtbl.create 97
  let neighbors gr i =
    if not (Hashtbl.mem gr i)
      then []
      else Hashtbl.find gr i
  let exists_edge gr i j =
    List.mem j (neighbors gr i)
  let add_edge gr i j =
    if not (Hashtbl.mem gr i)
      then Hashtbl.add gr i [j]
      else if not (exists_edge gr i j) then 
        Hashtbl.replace gr i (j::Hashtbl.find gr i);
    if not (Hashtbl.mem gr j)
      then Hashtbl.add gr j [i]
      else if not (exists_edge gr j i) then 
        Hashtbl.replace gr j (i::Hashtbl.find gr j)
  let del_edge gr i j =
    if Hashtbl.mem gr i then
      Hashtbl.replace gr i
        (List.filter (fun k -> k<>j) (Hashtbl.find gr i));
    if Hashtbl.mem gr j then
      Hashtbl.replace gr j
        (List.filter (fun k -> k<>i) (Hashtbl.find gr j))
end;;

(*-------------------------------------------------*)
(* Module UnionFind pour gerer des equivalences    *)

module UnionFind : sig
  (* Type abstrait *)
  type 'a t
  (* Creation d'un objet *)
  val create : unit -> 'a t
  (* Placement de i et j dans le m�me ensemble *)
  val union : 'a t -> 'a -> 'a -> unit
  (* Retourne le representant de la classe de i *)
  val find : 'a t -> 'a -> 'a
  (* Test si i et j appartiennent au m�me ensemble *)
  val joined : 'a t -> 'a -> 'a -> bool
end = struct
  type 'a t = ('a,'a) Hashtbl.t
  let create () = Hashtbl.create 97
  let rec _find s i =
    if Hashtbl.mem s i
      then _find s (Hashtbl.find s i) else i
  let find s i =
    let ri = _find s i in
    let rec update i =
      if i = ri then i else
        let j = Hashtbl.find s i
          in Hashtbl.replace s i ri; update j
    in update i
  let joined s i j = find s i = find s j
  let union s i j =
    let ri = find s i and rj = find s j in
      if ri <> rj then Hashtbl.add s ri rj
end;;

(*-------------------------------------------------*)
(* Fonctions de trace de labyrinthe et de chemin   *)

let draw_maze gr h w =
  open_graph (" "^(string_of_int (20*(w+2)))
             ^"x"^(string_of_int (20*(h+2))));
  set_window_title "Labyrinthe";
  moveto 20 20; lineto (20*(w+1)) 20;
  lineto (20*(w+1)) (20*(h+1));
  lineto 20 (20*(h+1)); lineto 20 20;
  for i=0 to h-2 do
    for j=0 to w-1 do
      let id = i*w+j in
        if not (Graph.exists_edge gr id (id+w)) then
          (moveto (20*(j+1)) (20*(h-i));
           lineto (20*(j+2)) (20*(h-i)))
    done
  done;
  for i=0 to h-1 do
    for j=0 to w-2 do
      let id = i*w+j in
        if not (Graph.exists_edge gr id (id+1)) then
          (moveto (20*(j+2)) (20*(h-i));
           lineto (20*(j+2)) (20*(h-i+1)))
    done
  done;;

let draw_path lst h w = 
  set_color red;
  set_line_width 5;
  List.fold_left
    (fun u i -> lineto ((i mod w)*20+30) ((h-1-i/w)*20+30))
    (moveto ((List.hd lst mod w)*20+30)
            ((h-1-List.hd lst / w)*20+30)) (List.tl lst);;

let ascii_maze ?(path = []) gr h w =
  for i = 0 to 2*h do
    for j = 0 to 2*w do
      let c = i/2*w+j/2 in
      match i mod 2, j mod 2 with
        | 0,0 -> print_char '+'
        | 0,1 when not (Graph.exists_edge gr c (c-w))
            -> print_char '-'
        | 1,0 when not (Graph.exists_edge gr c (c-1))
            -> print_char '|'
        | 1,1 when List.mem c path
            -> print_char '.'
        | 0,1 when List.mem c path && List.mem (c-w) path
            -> print_char '.'
        | 1,0 when List.mem c path && List.mem (c-1) path
            -> print_char '.'
        | _ -> print_char ' '
    done;
    print_newline ()
  done;;

(*-------------------------------------------------*)

let gen_maze s h w =
  Random.init (2+4*s);
  let gr = Graph.create () in
  let visited = Hashtbl.create 97 in
  let pool = Array.make (h*w*4) (h/2*w+w/2,h/2*w+w/2+1) in
  let swap n = let tmp = pool.(n) and p = Random.int (n+1)
                 in pool.(n) <- pool.(p); pool.(p) <- tmp in
  let rec aux = function
    | -1 -> Graph.del_edge gr ((h/3)*w+w/3) ((h/3)*w+w/3+1); gr
    | n -> let o,i = pool.(n) in let b = Hashtbl.mem visited i in
             if b || Random.int (h*w) = 0
             then aux (n-1) else
               let count = ref n in
                 Hashtbl.add visited i true;
                 Graph.add_edge gr o i;
                 if i mod w <> 0 then
                   (pool.(!count) <- (i,i-1); swap !count; incr count);
                 if i mod w <> (w-1) then
                   (pool.(!count) <- (i,i+1); swap !count; incr count);
                 if i >= w then
                   (pool.(!count) <- (i,i-w); swap !count; incr count);
                 if i < w*(h-1) then
                   (pool.(!count) <- (i,i+w); swap !count; incr count);
                 aux (!count-1);
  in aux 1;;

(*-------------------------------------------------*)

let shuffle_list lst = 
  let tab = Array.of_list lst in
  for i = Array.length tab - 1 downto 1 do
    let j = Random.int (i+1) in
      let tmp = tab.(j) in tab.(j) <- tab.(i); tab.(i) <- tmp
  done;
  Array.to_list tab;;

(*-------------------------------------------------*)

let is_connex gr h w =
  let n = h * w in
  let visited = Array.make n false in
  let rec dfs node =
    if visited.(node) then 0
    else begin
      visited.(node) <- true;
      1 + List.fold_left (fun acc neighbor -> acc + dfs neighbor) 0 (Graph.neighbors gr node)
    end
  in
  dfs 0 = n;;


exception Cycle;;

let is_perfect gr h w =
  let n = h * w in
  let visited = Array.make n false in
  let rec dfs node parent =
    if visited.(node) then raise Cycle
    else begin
      visited.(node) <- true;
      List.iter (fun neighbor ->
        if neighbor <> parent then dfs neighbor node
      ) (Graph.neighbors gr node)
    end
  in
  is_connex gr h w &&
  (try dfs 0 (-1); true with Cycle -> false);;


exception Stop;;

let path gr src dst h w =
	let n = h * w in
	let visited = Array.make n false in
	let rec dfs node =
		if node = dst then []
		else begin
			visited.(node) <- true;
			let rec loop = function
			| h::t when visited.(h) -> loop t
			| h::t -> (try h::dfs h with Stop -> loop t)
			| [] -> raise Stop
			in loop (Graph.neighbors gr node)
		end
	in src::dfs src;;


(*-------------------------------------------------*)

let no_wall h w =
	let gr = Graph.create () in
	for i = 0 to h-1 do
		for j = 0 to w-1 do
			let idx = j + w*i in
			if j <> w-1 then Graph.add_edge gr idx (idx+1);
			if i <> h-1 then Graph.add_edge gr idx (idx+w)
		done;
	done;
	gr;;
	
	
let gen_dfs h w =
	let empty_gr = no_wall h w in
	let new_gr = Graph.create () in
	let visited = Array.make (h*w) false in
	let rec dfs node last =
		if not visited.(node) then begin
			visited.(node) <- true;
			Graph.add_edge new_gr node last;
			List.iter (fun x -> dfs x node) (shuffle_list (Graph.neighbors empty_gr node))
		end
	in dfs 0 0;
	new_gr;;


(*-------------------------------------------------*)


let poss_walls h w =
	let poss = ref [] in
	for i = h-1 downto 0 do
		for j = w-1 downto 0 do
			let idx = j + w*i in
			if i <> h-1 then poss := (idx, idx+w)::!poss
			if j <> w-1 then poss := (idx, idx+1)::!poss;
		done;
	done;
	!poss;;

let gen_Kruskal h w =
	let gr = Graph.create () in
	let uf = UnionFind.create () in
	List.iter
	(
	fun (i, j) ->
		if not (UnionFind.joined uf i j) then begin
			UnionFind.union uf i j;
			Graph.add_edge gr i j
		end
	)
	(shuffle_list (poss_walls h w));
	gr;;


(*-------------------------------------------------*)

(* test *)
let h = 20;;
let w = 50;;
let s = 42;;
let maze = gen_maze s h w;;
let my_path = path maze 0 (h*w - 1) h w;;

draw_maze maze h w;;
draw_path my_path h w;;

is_perfect maze h w;;


path maze h w 0 10;;


let test = no_wall h w;;

draw_maze test h w;;


draw_maze (gen_dfs h w) h w;;
poss_walls 3 2;;


let krus = gen_Kruskal h w;;
draw_maze krus h w;;
is_perfect krus h w;;
