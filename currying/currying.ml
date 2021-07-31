(*
An OCaml function that takes two arguments of type t1 and t2
and returns value of type t1 has type t1 -> t2 -> t3.
*)

(* 
We use two variables after the function name in the let expression 

add: int -> int -> int
*)
let add x y = x + y

(* 
Another way to define a function that takes two arguments
is to write a function that takes a tuple:

add_2: (int, int) -> int
*)
let add_2 (x, y) = x + y

(*
Functions written using the first style(with type t1 -> t2 -> t3) 
are called curried functions, and functions using the second
style (with type t1 * t2 -> t3) are called uncurried.

The term curry refers to a logician name Haskell Curry.
*)

let _ =
  add 2 2 |> string_of_int |> print_endline;
  add_2 (2, 2) |> string_of_int |> print_endline;