exception Pasbon

let reverse = function
| '(' -> ')'
| '[' -> ']'
| '{' -> '}'
| _ -> raise Pasbon

let verif str =
  let n = String.length str in
  let stack = Stack.create () in
  try
    for i=0 to n do
      match str.[i] with
      | '(' | '[' | '{' -> Stack.push (reverse str.[i]) pile
      | ')' | ']' | '}' -> if Stack.pop pile <> str.[i] then raise Pasbon
      | _ -> ()
    done;
    Stack.is_empty stack
  with 
  | Pasbon -> false
  | Stack.empty -> false


      






