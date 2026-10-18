let rec draw_line n = match n with
| 0 -> print_newline ()
| _ -> print_char '#'; draw_line (n-1)

let rec draw_blank n = match n with
| 0 -> ()
| _ -> print_char ' '; draw_blank (n-1)

let fract n =
  let rec sub_fract n depth = match n with
  | 0 -> ()
  | _ -> sub_fract (n-1) (depth + n); draw_blank depth; draw_line (n*2); sub_fract (n-1) depth 
  in sub_fract n 0

let () = draw_line 4