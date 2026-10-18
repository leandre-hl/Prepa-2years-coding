type graph = int list array



let partition gr vertices =
  let seen = Hashtbl.create 42 in
  
  let build = ref [] in
  let rec build_dfs i =
    Hashtbl.add seen i ();
    build := i::!build;
    List.iter (fun j -> if not (Hashtbl.mem seen j) then build_dfs j) gr.(i)
      
  in let rec build_componnent = function
    | [] -> []
    | i::t -> if Hashtbl.mem seen i
                then build_componnent t
                else
                  begin
                    build_dfs i;
                    let c = !build in
                    build := [];
                    c::build_componnent t
                  end

  in build_componnent vertices