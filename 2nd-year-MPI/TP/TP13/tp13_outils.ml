let afficher_chiffre (image: int array array) =
    (*
    Prend en argument une image en niveaux de gris au format matrice 
    d'entiers et l'affiche dans la console. Cette fonction est prévue
    pour afficher les chiffres au format 8×8.
    *)
    for i = 0 to 7 do
        for j = 0 to 7 do
            let c = 232 + (image.(i).(j) * 23 / 255) in
            Printf.printf "\x1b[48;5;%dm  \x1b[0m" c
        done;
        print_newline ()
    done

let ouvrir_image_gris (nom_fichier: string) =
    (*
    Prend en argument une chaîne de caractère correspondant à un nom 
    de fichier image au format PNG en niveaux de gris et renvoie une 
    matrice correspondant à l'image, contenant des entiers.
    *)
    match Png.load_as_rgb24 nom_fichier [] with
        | Images.Rgb24 im ->
            let h = im.height and l = im.width in
            let s = Rgb24.dump im in
            let image = Array.make_matrix h l 0 in
            for lgn = 0 to h - 1 do
                for col = 0 to l - 1 do
                    let i = 3 * (lgn * l + col) in
                    let r = Bytes.get_uint8 s i in
                    image.(lgn).(col) <-  r
                done
            done;
            (image:int array array)
        | _ -> failwith "Pas le bon format d'image."

let ouvrir_image_couleurs (nom_fichier: string) =
    (*
    Prend en argument une chaîne de caractère correspondant à un nom
    de fichier image au format PNG en couleurs et renvoie une matrice
    correspondant à l'image, contenant des tableaux de taille 3
    correspondant aux codes RGB.
    *)
    match Png.load_as_rgb24 nom_fichier [] with
        | Images.Rgb24 im ->
            let h = im.height and l = im.width in
            let s = Rgb24.dump im in
            let image = Array.make_matrix h l [||] in
            for lgn = 0 to h - 1 do
                for col = 0 to l - 1 do
                    let i = 3 * (lgn * l + col) in
                    let r = Bytes.get_uint8 s i 
                    and g = Bytes.get_uint8 s (i + 1) 
                    and b = Bytes.get_uint8 s (i + 2) in
                    image.(lgn).(col) <-  [|r;g;b|]
                done
            done;
            (image:int array array array)
        | _ -> failwith "Pas le bon format d'image."

let sauvegarder_image_gris (image: int array array) (nom_image: string) =
    (*
    Prend en argument une image en niveaux de gris au format matrice 
    d'entiers et une chaîne de caractères correspondant à un nom de 
    fichier et enregistre l'image au chemin donné.

    La fonction crée un nouveau fichier s'il n'existe pas ou écrase le
    fichier portant le même nom s'il existe déjà.
    *)
    let h = Array.length image and l = Array.length image.(0) in
    let im = Rgb24.make l h {r = 0; g = 0; b = 0} in
    for lgn = 0 to h - 1 do
        for col = 0 to l - 1 do
            let c = image.(lgn).(col) in
            Rgb24.set im col lgn {r = c; g = c; b = c}
        done
    done;
    Png.save nom_image [] (Images.Rgb24 im)

let sauvegarder_image_couleurs (image: int array array array) (nom_image: string) =
    (*
    Prend en argument une image en couleurs au format matrice 
    de RGB et une chaîne de caractères correspondant à un nom de 
    fichier et enregistre l'image au chemin donné.

    La fonction crée un nouveau fichier s'il n'existe pas ou écrase le
    fichier portant le même nom s'il existe déjà.
    *)
    let h = Array.length image and l = Array.length image.(0) in
    let im = Rgb24.make l h {r = 0; g = 0; b = 0} in
    for lgn = 0 to h - 1 do
        for col = 0 to l - 1 do
            let c = image.(lgn).(col) in
            Rgb24.set im col lgn {r = c.(0); g = c.(1); b = c.(2)}
        done
    done;
    Png.save nom_image [] (Images.Rgb24 im)

(* Structure impérative de tas d'appariement (pairing heap). *)
type ('a, 'b) arbre = Nil | Node of 'a * 'b * ('a, 'b) arbre list

type ('a, 'b) tas = {mutable taille : int; mutable data : ('a, 'b) arbre}

let creer_tas () = {taille = 0; data = Nil}

let fusion t1 t2 = match t1, t2 with
    | Nil, t | t, Nil                  -> t
    | Node(p1, x, l1), Node(p2, y, l2) -> 
        if p1 < p2 then Node(p2, y, t1 :: l2)
        else Node(p1, x, t2 :: l1)

let inserer p x t = 
    t.taille <- t.taille + 1;
    t.data <- fusion (Node(p, x, [])) t.data

let maximum t = match t.data with
    | Nil     -> failwith "Tas vide."
    | Node(p, x, _) -> (p, x)

let rec fusion_liste = function
    | []            -> Nil
    | [t]           -> t
    | t1 :: t2 :: q -> fusion (fusion t1 t2) (fusion_liste q)

let extraire_max t = match t.data with
    | Nil        -> failwith "Tas vide."
    | Node(p, x, l) -> t.taille <- t.taille - 1; t.data <- fusion_liste l; p, x

let tas_vers_tab t =
    let n = t.taille in
    if n = 0 then [||] else begin
       let tab = Array.make n (maximum t) in
       let rec convertir i = function
           | Nil           -> tab
           | Node(p, x, l) -> 
                tab.(i) <- (p, x);
                convertir (i - 1) (fusion_liste l) in
       convertir (n - 1) t.data 
    end