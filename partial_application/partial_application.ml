(*
The following functions are syntactically different
but semantically equivalent.
*)
(* add: int -> int -> int *)
let add x y = x + y

(* add2: int -> int -> int *)
let add2 x = fun y -> x + y

(* add3: int -> int -> int *)
let add3 = fun x -> (fun y -> x + y)

(*
Every OCaml function takes exactly one argument.
Even though we can of add as a function that takes two arguments,
in reality it is a function that takes one argument and returns a function.

The type of add is int -> int -> int which really means
the same as int -> (int -> int).

Function types are right associative. There are implicit
parentheses around function types, from right to left.

Function application, on the other hand, is left associtive:
there are implicit parentheses around function applications,
from left to right:

e1 e2 e3 e4

really means the same as

((e1 e2) e3) e4

We can partially apply them to build new functions.
*)
let inc = add 1

let inc2 = add2 1

let inc3 = add3 1

let _ =
  print_endline (string_of_int (inc 1)); (* 2 *)
  print_endline (string_of_int (inc2 1)); (* 2 *)
  print_endline (string_of_int (inc3 1)); (* 2 *)