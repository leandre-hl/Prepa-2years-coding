let rec tak x y z = 
  if x <= y then z
  else tak (tak (x-1) y z) (tak x (y-1) z) (tak x y (z-1));;

Printf.printf "Tak(10, 22, 132) = %d\n" (tak 10 22 132)