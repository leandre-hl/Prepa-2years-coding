type set =
| Leaf of int list
| Union of set * set
| Inter of set * set
| Minus of set * set

let ensemble =
        Minus(
          Union(
            Leaf [1;3;4],
            Leaf [2; 5]
          ),
          Inter(
            Leaf [2; 4; 5],
            Leaf [1;2;3;4]
          )
        )

let rec set_mem elem = function
| Leaf lst -> List.mem elem lst
| Union (lc, rc) -> set_mem elem lc || set_mem elem rc
| Inter (lc, rc) -> set_mem elem lc && set_mem elem rc
| Minus (lc, rc) -> set_mem elem lc && (not (set_mem elem rc))

let rec retire_doublons = function
| h1::h2::t -> if h1 = h2 then retire_doublons (h2::t) else h1 :: (retire_doublons (h2::t))
| lst -> lst

let rec union l1 l2 = match l1, l2 with
| _, [] -> l1
| [], _ -> l2
| h1::t1, h2::t2 when h1=h2 -> h1::union t1 t2
| h1::t1, h2::t2 when h1<h2 -> h1::union t1 (h2::t2)
| h1::t1, h2::t2 -> h2::union (h1::t1) t2

let rec inter l1 l2 = match l1, l2 with
| _, [] | [], _             -> []
| h1::t1, h2::t2 when h1=h2 -> h1::inter t1 t2
| h1::t1, h2::t2 when h1<h2 -> inter t1 (h2::t2)
| h1::t1, h2::t2            -> inter (h1::t1) t2

let rec minus l1 l2 = match l1, l2 with
| _, []                     -> l1 
| [], _                     -> []
| h1::t1, h2::t2 when h1<h2 -> h1::minus t1 (h2::t2)
| h1::t1, h2::t2 when h1>h2 -> h1::minus t1 t2
| _::t1, _::t2              -> minus t1 t2

let rec list_of_set = function
| Leaf lst -> retire_doublons (List.sort compare lst)
| Union (lc, rc) -> union (list_of_set lc) (list_of_set rc)
| Inter (lc, rc) -> inter (list_of_set lc) (list_of_set rc)
| Minus (lc, rc) -> minus (list_of_set lc) (list_of_set rc)
