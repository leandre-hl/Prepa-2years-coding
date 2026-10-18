let rotG = function
| [] -> []
| h::t -> t @ [h]

let rec rotD = function
| [] -> []
| h::t -> match rotD t with
          | [] -> [h]
          | h2::t2 -> h2::h::t2


let a = [1; 2; 3; 4; 5]
