let place houses dmax =
	let sorted = List.sort compare houses in
	let rec aux = function
	| [] -> []
	| x1::t -> let rec rest = function
				  | x::t when x <= x1 + 2*dmax -> rest t
				  | lst -> lst
				  in x1+dmax::aux (rest t)
	in aux sorted;;

place [5;2;6;1;9] 2;;




let possible a d stations =
	let sorted = List.sort compare (d::stations) in
	let rec aux acc = function
	| [] -> true
	| h::t -> h-acc <= a && aux h t
	in aux 0 sorted;;
	
possible 7 20 [3;10; 15];;

let stops a d stations =
	let sorted = List.sort compare (d::stations) in
	let rec count maxi = function
		| h1::h2::t when h2 <= maxi -> count maxi (h2::t)
		| h::_ when h > maxi -> failwith "passe sèche"
		| d::[] -> []
		| h::t -> h::count (h+a) t
		| _ -> []
	in count a sorted;;
	
	