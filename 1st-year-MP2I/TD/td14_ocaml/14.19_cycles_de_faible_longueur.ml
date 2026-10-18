type graph = int list array


let cycle3f gr =
  let count = ref 0 in
  for u = 0 to Array.length gr - 1 do
    List.iter (
      fun v -> if u <= v then
      List.iter (
        fun w -> if v <= w && List.mem w gr.(v) then incr count
      ) gr.(u)
    ) gr.(u)
  done;
  !count



let test = [|[1;2];[0;2];[0;1;3;4];[2;4];[2;3]|]



