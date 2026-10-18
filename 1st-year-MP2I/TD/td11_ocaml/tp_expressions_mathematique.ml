type oper = Add | Sub | Mul | Div

type expr = Leaf of float
| Node of expr * oper * expr

let a1 =  Node(Node(Leaf 2., Mul, Leaf 3.),Add,Leaf 4.)
let a2 = Node (Leaf 2., Mul, Node(Leaf 3., Add, Leaf 4.))
let a3 = Node(Node(Leaf 2., Sub, Leaf 3.), Sub, Leaf 4.)

let rec eval = function
| Leaf a -> a
| Node (lc, Add, rc) -> (eval lc) +. (eval rc)
| Node (lc, Sub, rc) -> (eval lc) -. (eval rc)
| Node (lc, Mul, rc) -> (eval lc) *. (eval rc)
| Node (lc, Div, rc) -> (eval lc) /. (eval rc)

let print_oper = function
| Add -> print_string "+"
| Sub -> print_string "-"
| Mul -> print_string "*"
| Div -> print_string "/"

let rec print_expr = function
| Leaf a -> print_float a
| Node (lc, oper, rc) -> print_char '('; print_expr lc; print_oper oper; print_expr rc; print_char ')'

let rec develop = function
| Node (a, Mul, Node(lc, Mul, rc)) -> Node(Node(a, Mul, develop lc), Add, Node(a, Mul, develop rc))
| Node (a, oper, b) -> Node(develop a, oper, develop b)
| a -> a



type elem = Val of float | Op of oper

let b = [ Val 2.0; Val 3.0; Op Mul; Val 4.0; Op Add ]


let eval_polinv polinv =
  let s = Stack.create () in
  let rest = ref polinv in
  while !rest <> [] do
    begin
      match List.hd !rest with
      | Val a -> Stack.push a s
      | Op oper ->
          let a = Stack.pop s in
          let b = Stack.pop s in
          Stack.push (eval (Node (Leaf b, oper, Leaf a))) s
    end;
    rest := List.tl !rest
  done;
  let a = Stack.pop s in
  match Stack.is_empty s with
  | true -> a
  | false -> failwith "expression non valide"


let rec affiche_arbre_polinv = function
| [] -> ()
| Val a::t -> Printf.printf "%f " a; affiche_arbre_polinv t
| Op oper::t -> print_oper oper; print_char ' '; affiche_arbre_polinv t

let rec polinv_of_arbre = function
| Leaf a -> [Val a]
| Node (lc, oper, rc) -> polinv_of_arbre lc @ polinv_of_arbre rc @ [Op oper]

let arbre_of_polinv polinv =
  let s = Stack.create () in
  let rest = ref polinv in
  while !rest <> [] do
    begin
      match List.hd !rest with
      | Val a -> Stack.push (Leaf a) s
      | Op oper ->
          let a = Stack.pop s in
          let b = Stack.pop s in
          Stack.push (Node (b, oper, a)) s
    end;
    rest := List.tl !rest
  done;
  let a = Stack.pop s in
  match Stack.is_empty s with
  | true -> a
  | false -> failwith "expression non valide"

let char_to_op = function
| '+' -> Add
| '-' -> Sub
| '*' -> Mul
| '/' -> Div
| _ -> failwith "char incorrect"

let lexer string =
  let start_float = ref 0 in
  let i = ref 0 in
  let list = ref [] in
  let flush_float () =
    let a = String.sub string !start_float (!i- !start_float) in
    start_float := !i+1;
    if a = "" then
       false, Val 0.
    else
      true, Val (float_of_string a) in
  while !i < String.length string do
    begin
      match string.[!i] with
      |c when c='+'||c='-'||c='*'||c='/' -> let b, f = flush_float () in if b then list :=  Op (char_to_op c)::f::!list else list := Op (char_to_op c)::!list
      | c -> ()
    end;
    incr i
  done;
  if !start_float < !i then
    list := snd (flush_float ())::!list;
  List.rev !list





