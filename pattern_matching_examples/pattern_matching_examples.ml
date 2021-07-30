(* Pattern matching records *)
type pokemontype = 
  TNormal
  | TFire 
  | TWater

type pokemon = {
  name: string;
  hp: int;
  pokemontype: pokemontype;
}

(* unnecessary *)
let get_hp pokemon = 
  match pokemon with 
  | {name=_; pokemontype=_; hp} -> hp

(* unnecessary *)
let get_hp_1 pokemon = 
  match pokemon with 
  | {name=name; hp=hp; pokemontype=pokemontype} -> hp
  
(* unnecessary *)
let get_hp_2 pokemon =
  match pokemon with 
  | {hp} -> hp

let get_hp_3 pokemon = pokemon.hp

(* Pattern matching tuples *)
let third tuple =
  match tuple with 
  | (x, y,z) -> z

let third tuple =
  let (x, y, z) = tuple in z

let third tuple = 
  let (_, _, z) = tuple in z

let third (_, _, z) = z

(* fst and snd are already provided in the standard library *)
let fst (x, _) = x

let snd (_, y) = y

let _ =
  let p = {name="Charmander"; hp=100; pokemontype=TFire} in 
    print_endline (string_of_int (get_hp p));
    print_endline (string_of_int (get_hp_1 p));
    print_endline (string_of_int (get_hp_2 p));
    print_endline (string_of_int (get_hp_3 p));
