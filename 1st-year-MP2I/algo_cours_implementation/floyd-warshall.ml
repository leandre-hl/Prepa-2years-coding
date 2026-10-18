
let w = [|
          [|0.; infinity; infinity; infinity; infinity; infinity|];
          [|2.; 0.; infinity; infinity; 5.; infinity|];
          [|infinity; infinity; 0.; 7.; 1.; 2.|];
          [|infinity; 1.; infinity; 0.; infinity; infinity|];
          [|infinity; 6.; infinity; 4.; 0.; infinity|];
          [|infinity; infinity; 3.; infinity; infinity; 0.|]
        |]


let floyd_warshall w =
  let n = Array.length w in
  let m = Array.make_matrix n n 0. in
  for i = 0 to n-1 do
    for j = 0 to n-1 do
      m.(i).(j) <- w.(i).(j)
    done
  done;
  for k = 0 to n-1  do
    for i = 0 to n-1 do
      for j = 0 to n-1 do
        m.(i).(j) <- min m.(i).(j) (m.(i).(k) +. m.(k).(j))
      done
    done
  done;
  m
