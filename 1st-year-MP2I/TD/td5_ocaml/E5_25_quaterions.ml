type quaternion = Quater of (float*float*float*float)



let fstQuater = function Quater (a, b, c, d) -> a
let sndQuater = function Quater (a, b, c, d) -> b
let trdQuater = function Quater (a, b, c, d) -> c
let forQuater = function Quater (a, b, c, d) -> d


let printQuater q =
  Printf.printf "(%.1f + %.1fi + %.1fj + %.1fk)" (fstQuater q) (sndQuater q) (trdQuater q) (forQuater q)

let qmul q1 q2 =
  let a1 = fstQuater q1 in
  let b1 = sndQuater q1 in
  let c1 = trdQuater q1 in
  let d1 = forQuater q1 in
  let a2 = fstQuater q2 in
  let b2 = sndQuater q2 in
  let c2 = trdQuater q2 in
  let d2 = forQuater q2 in
  Quater (a1*.a2 -. b1*.b2 -. c1*.c2 -. d1*.d2,
          a1*.b2 +. a2*.b1 +. c1*.d2 +. c2*.d1,
          a1*.c2 +. a2*.c1 +. b1*.d2 +. b2*.d1,
          a1*.d2 +. a2*.d1 +. b1*.c2 +. b2*.c1)

let q1 = Quater (5., 7., 3.2, -4.2)
let q2 = Quater (-1., 0., 3.7, 42.);;

Printf.printf "Multiplication de 2 quaternions : \n";
printQuater q1;
Printf.printf " * ";
printQuater q2;
Printf.printf " = ";
printQuater (qmul q1 q2);
print_newline ()
