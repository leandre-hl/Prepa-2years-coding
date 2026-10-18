exception TooShort

let second tas =
  if Array.length tas < 2 then raise TooShort
  else if Array.length tas = 2 then tas.(1)
  else max tas.(1) tas.(2)

let max3 x y z = max x (max y z)

let third t =
  let n = Array.length t in
  if n < 3 then failwith "trop petit" else
  if t.(i) >= t.(2) then max3 t.(2) t.(if n>3 then 3 else 2) t.(if n > 4 then 4 else 2)
  else max3 t.(1) t.(if n>5 then 5 else 1) t.(if n>6 then 6 else 1)

let smallest tas =
  let mini = ref 0 in
  for i = 0 to Array.length tas do
    if tas.(i) < !mini
      then mini := tas.(i)
  done;
  !mini

