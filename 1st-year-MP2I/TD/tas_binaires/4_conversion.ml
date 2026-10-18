type 'a heap_tree = Nil | Node of 'a heap_tree * 'a * 'a heap_tree


let to_tree heap =
  let n = Array.length heap in
  let rec aux = function
  | i when i>n -> Nil
  | i -> Node (aux (2*i+1), heap.(i), aux (2*i+2))
  in aux 0

let to_array heap_tr =
  let heap_lst = ref [] in
  let queue = Queue.create () in
  Queue.push heap_tr queue;
  while not (Queue.is_empty queue) do
    match Queue.pop queue with
    | Nil -> ()
    | Node (lc, x, rc) -> Queue.push lc queue;
                          Queue.push rc queue;
                          heap_lst := x :: !heap_lst;
  done;
  Array.of_list (List.rev !heap_lst)

  
