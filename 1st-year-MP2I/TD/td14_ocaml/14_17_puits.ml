type graph = bool array array

let sink gr = List.filter (fun i -> not (Array.fold_left (||) false gr.(i))) (List.init (Array.length gr) (fun i -> i))





