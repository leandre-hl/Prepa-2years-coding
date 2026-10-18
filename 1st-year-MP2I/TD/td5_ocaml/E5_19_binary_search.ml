let rec bisect f a b eps =
    if (f a) *. (f b) > 0. then
      raise (Invalid_argument "f(a)*f(b) > 0")
    else
      let m = (a +. b) /. 2. in
      if (abs_float (b -. a) <= eps) || abs_float (f m) <= eps then
        m
      else if f m > 0. then
        if f a < 0. then bisect f a m eps else bisect f m b eps
      else
        if f a < 0. then bisect f m b eps else bisect f a m eps
  
  (* Example call *)
let root = bisect cos 0. 3. 0.000000000001;;
Printf.printf "Root: %f\n" root