(*
A type synonym  is a new name for an already existing
type. 

Type synonyms are useful because they let us give
descriptive names to complex types, improving
readability.

For example, here are some type synonyms
that might be useful in representing some types from
linear algebra:
*)
type point = float * float 
type vector = float list 
type matrix = float list list

(* 
get_x doesn't care if the pass a point or a float * float to it
because they are the same type
*)
let get_x: point -> float = fun (x, _) -> x

let _ =
  let a: float * float = (1.0, 2.0) in 
    get_x a |> string_of_float |> print_endline;

  let b: point = (1.0, 2.0) in 
    get_x b |> string_of_float |> print_endline;