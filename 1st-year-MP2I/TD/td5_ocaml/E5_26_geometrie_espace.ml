let fst3D (a, b, c) = a
let snd3D (a, b, c) = b
let trd3D (a, b, c) = c
let vect a b = ((fst3D b) - (fst3D a), (snd3D b) - (snd3D a), (trd3D b) - (trd3D a))
let same_len a b = (fst3D a)*(fst3D a) + (snd3D a)*(snd3D a) + (trd3D a)*(trd3D a) = (fst3D b)*(fst3D b) + (snd3D b)*(snd3D b) + (trd3D b)*(trd3D b)

