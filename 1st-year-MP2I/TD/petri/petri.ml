type petri_network = {
  states: int array;
  transitions: ((int* int) list * (int*int) list) array
}


let valid network j =
  let rec check = function
  | [] -> true
  | (s, v)::t -> network.states.(s) >= v && check t
  in check (fst network.transitions.(j))


let all_valids network = List.filter (fun j -> valid network j) (List.init (Array.length network.transitions) (fun i -> i))


let shoot network j =
  if valid network j
    then
      begin
        let rec modify_in = function
        | [] -> ()
        | (s, v)::t -> network.states.(s) <- network.states.(s) - v
        and modify_out = function
        | [] -> ()
        | (s, v)::t -> network.states.(s) <- network.states.(s) + v
        in modify_in (fst network.transitions.(j));
        modify_out (snd network.transitions.(j)); 
      end
    else failwith "Transition not valid"

let sources network =
  List.filter
    (fun j -> fst network.transitions.(j) = [])
    (List.init (Array.length network.transitions) (fun i -> i))

let sinks network =
  List.filter 
    (fun j -> snd network.transitions.(j) = [])
    (List.init (Array.length network.transitions) (fun i -> i))
