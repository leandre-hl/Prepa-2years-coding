open Tp13_outils

type image = int array array
type data = image array * int array

let lire_ligne (ligne: string) : image * int =
    let tokens = ref (String.split_on_char ' ' ligne) in
    let tag = int_of_string (List.hd !tokens) in 
    tokens := List.tl !tokens;
    let n = int_of_float (sqrt (float_of_int (List.length !tokens))) in
    let img = Array.make_matrix n n 0 in
    for i = 0 to n-1 do
        for j = 0 to n-1 do
            img.(i).(j) <- int_of_string (List.hd !tokens);
            tokens := List.tl !tokens;
        done
    done;
    img, tag

let lire_donnees (fichier: string) n : data =
    let f = open_in fichier in
    let images = Array.make n [||] in
    let tags = Array.make n 0 in
    for i = 0 to n-1 do
        let img, tag = lire_ligne (input_line f) in
        images.(i) <- img;
        tags.(i) <- tag
    done;
    close_in f;
    (images, tags)


let delta (im1: image) (im2: image) : int =
    let n = Array.length im1 in
    let sum_squares = ref 0 in
    for i = 0 to n-1 do
        for j = 0 to n-1 do
            sum_squares := !sum_squares + (im1.(i).(j) - im2.(i).(j)) * (im1.(i).(j) - im2.(i).(j))
        done
    done;
    !sum_squares
        

let plus_proches_voisins (k: int) ((xtrain, ytrain): data) (im: image) : int array =
    let t = creer_tas () in
    let n = Array.length xtrain in
    let l = ref 0 in
    for i = 0 to n-1 do
        inserer (delta xtrain.(i) im) ytrain.(i) t;
        incr l;
        if !l > k then begin
            ignore (extraire_max t);
            decr l
        end
    done;
    Array.map snd (tas_vers_tab t)

let majoritaire (etiq: int array) : int =
    let count = Array.make 10 0 in
    let maxi = ref 0 in
    let n = Array.length etiq in
    for i = 0 to n-1 do
        count.(etiq.(i)) <- count.(etiq.(i)) + 1;
        if count.(etiq.(i)) > count.(!maxi) then maxi := etiq.(i)
    done;
    !maxi

let kppv (k: int) (train: data) (im: image) =
    majoritaire (plus_proches_voisins k train im)

let matrice_confusion (k: int) (train: data) ((xtest, ytest): data) : int array array =
    let matrice = Array.make_matrix 10 10 0 in
    let n = Array.length xtest in
    for i = 0 to n-1 do
        let maj = kppv k train xtest.(i) in
        matrice.(ytest.(i)).(maj) <- matrice.(ytest.(i)).(maj) + 1
    done;
    matrice

let taux_erreur (confu: int array array) : float =
    let sum_all = ref 0 in
    let sum_non_diag = ref 0 in
    for i = 0 to 9 do
        for j = 0 to 9 do
            sum_all := !sum_all + confu.(i).(j);
            if i <> j then sum_non_diag := !sum_non_diag + confu.(i).(j)
        done
    done;
    (float_of_int !sum_non_diag) /. (float_of_int !sum_all) 

type rgb = int array
type image_couleur = rgb array array

let _ = Random.self_init ()

let delta_rgb (p1: rgb) (p2: rgb) : int =
    let sum = ref 0 in
    for i = 0 to 2 do
        sum := !sum + (p1.(i) - p2.(i)) * (p1.(i) - p2.(i))
    done;
    !sum

let selection_bary (k: int) (im: image_couleur) : rgb array =
    let barys = Array.make k [||] in
    for p = 0 to k-1 do
        barys.(p) <- Array.copy im.(Random.int (Array.length im)).(Random.int (Array.length im.(0)))
    done;
    barys

let bary_plus_proche (bary: rgb array) (p: rgb) : int =
    let min_i = ref (-1) in
    let min_dist = ref (3*256*256) in
    for i = 0 to (Array.length bary) - 1 do
        let dist = delta_rgb bary.(i) p in
        if dist < !min_dist then begin
            min_i := i;
            min_dist := dist
        end
    done;
    !min_i

let maj_classes (im: image_couleur) (bary: rgb array) (classes: int array array) : bool =
    let modif = ref false in
    for i = 0 to Array.length classes -1 do
        for j = 0 to Array.length classes.(i) -1 do
            let new_class = bary_plus_proche bary im.(i).(j) in
            if classes.(i).(j) <> new_class then begin
                modif := true;
                classes.(i).(j) <- new_class
            end
        done
    done;
    !modif

let ( ++ ) (p1: rgb) (p2: rgb) : rgb = [|p1.(0) + p2.(0); p1.(1) + p2.(1); p1.(2) + p2.(2)|]

let ( -- ) (p1: rgb) (p2: rgb) : rgb = failwith "À modifier"

let ( ** ) (p: rgb) (a: int) : rgb = failwith "À modifier"

let ( // ) (p: rgb) (a: int) : rgb = failwith "À modifier"

let maj_bary (im: image_couleur) (bary: rgb array) (classes: int array array) : unit =
    failwith "À modifier"

let kmoyennes (k: int) (im: image_couleur) : rgb array * int array array =
    failwith "À modifier"

let reconstruire (im: image_couleur) (bary: rgb array) (classes: int array array) : image_couleur =
    failwith "À modifier"

let floyd_steinberg (im: image_couleur) (bary: rgb array) : image_couleur =
    failwith "À modifier"



let xtrain, ytrain = lire_donnees "train" 1437

let xtest, ytest = lire_donnees "test" 360;;

(*
for i = 0 to 4 do
    afficher_chiffre xtrain.(i);
    Printf.printf "%d\n" ytrain.(i)
done;;

let ppv = plus_proches_voisins 3 (xtrain, ytrain) xtrain.(0);;
Printf.printf "3 plus proches voisins :\n";;
for i = 0 to 2 do
    Printf.printf "%d\n" ppv.(i)
done;;
*)

Printf.printf "Taux d'erreur (k=1) : %f\n" (taux_erreur (matrice_confusion 1 (xtrain, ytrain) (xtest, ytest)));;
Printf.printf "Taux d'erreur (k=3) : %f\n" (taux_erreur (matrice_confusion 3 (xtrain, ytrain) (xtest, ytest)));;
Printf.printf "Taux d'erreur (k=7) : %f\n" (taux_erreur (matrice_confusion 7 (xtrain, ytrain) (xtest, ytest)));;

