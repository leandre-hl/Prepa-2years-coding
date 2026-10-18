(* Piles *)

type 'a pile = {mutable content : 'a list}
exception StackEmpty 

let create_stack () = {content = []}

let push elem s = s.content <- elem::s.content

let is_empty s = s.content = []

let pop s = match s.content with
| [] -> raise StackEmpty
| h::t -> s.content <- t; h

let top s =
  let elem = pop s in
  push elem s; elem

(* Files *)

type 'a queue = {
  mutable content: 'a array;
  mutable input: int;
  mutable output: int;
}

exception QueueEmpty

let create_queue () = {content = [| |]; input = 0; output = 0}

let is_empty q = q.input = q.output

let push elem q =
  (* Est buggee *)
  let n = Array.length q.content in
  if n = 0 then begin
    q.content <- Array.make 4 elem;
    q.input <- 1;
    q.output <- 0;
  end else begin
    if (q.input + 1) mod n = q.output then begin
      let new_size = 2 * n in
      let new_arr = Array.make new_size q.content.(q.output) in
      for i = 0 to n - 1 do
        new_arr.(i) <- q.content.((q.output + i) mod n)
      done;
      q.content <- new_arr;
      q.output <- 0;
      q.input <- n;
    end;
    q.content.(q.input) <- elem;
    q.input <- (q.input + 1) mod (Array.length q.content)
  end

let pop q =
  if is_empty q then raise QueueEmpty
  else
    let elem = q.content.(q.output) in
    q.output <- (q.output + 1) mod Array.length q.content;
    elem


(* Dictionnaires *)

type ('a, 'b) t = {mutable content : ('a * 'b) list array}

let create_dict n = {content = Array.make n []}

exception NotFound
let find dict key =
  let hsh = (Hashtbl.hash key) mod Array.length dict.content in
  let rec auxFind = function
  | [] -> raise NotFound
  | (k, v)::t when k=key -> v
  | _::t -> auxFind t
  in auxFind dict.content.(hsh)


let mem dict key =
  let hsh = (Hashtbl.hash key) mod Array.length dict.content in
  let rec auxMem = function
  | [] -> false
  | (k, v)::t -> k=key || auxMem t
  in auxMem dict.content.(hsh)


let add dict key value =
  let hsh = (Hashtbl.hash key) mod Array.length dict.content in
  dict.content.(hsh) <- (key, value)::dict.content.(hsh)

(* Arbre binaire strict *)

type 'a tree =
| Node of 'a * 'a tree * 'a tree
| Leaf of 'a

let a = Node(4, Node(2,Leaf 1, Leaf 3), Node(6,Leaf 5,Leaf 7))

let rec size = function
| Leaf a -> 1
| Node (_, lc, rc) -> 1 + (size lc) + (size rc)


let rec height = function
| Leaf _ -> 0
| Node (_, lc, rc) -> 1 + max (height lc) (height rc)

(* Arbre binaire quelconques *)

type 'a tree = Node of 'a * 'a tree list
let b = Node(4, [Node(2, [Node(1,[]); Node(3,[])])])

let rec size = function Node (_, lst) -> List.fold_left (fun acc a -> size a + acc) 1 lst

let rec height = function
| Node (_, []) -> 0
| Node (a, h::t) -> max (1 + height h) (height (Node (a, t)))

let rec dfs_prefix tree =
  let rec aux = function
  | Node (_, []) -> []
  | Node (a, h::t) -> (dfs_prefix h @ aux (Node (a, t)))
in match tree with Node (a, _) -> a :: aux tree

let bfs tree = 
  let q = Queue.create () in
  let explored = ref [] in
  Queue.push tree q;
  while not (Queue.is_empty q) do
    match Queue.pop q with Node(a, lst) ->
    explored := a::!explored;
    let rec aux = function
    | [] -> ()
    | h::t -> Queue.push h q; aux t;
    in aux lst
  done;
  List.rev !explored