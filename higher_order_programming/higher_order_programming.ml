(*
Functions are values just like any other value in OCaml.
We can pass functions around as arguments to other functions,
return them from functions, store them in data structures.

Higher-order functions either take other functions
as input or return other functions as output (or both).

The function twice is higher-order: its input f is a function.
*)
let twice f x = f (f x)

let double = ( * ) 2

let quad = twice double

let _ =
  print_endline (string_of_int (quad 2))