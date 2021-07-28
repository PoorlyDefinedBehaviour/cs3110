(* 
OCaml functions do not have tohave names, 
they may be anonymous.
*)

(* Anonymous function *)
let inc = fun x -> x + 1

(* Normal function *)
let inc2 x = x +1

(*
They are syntactically different but semantically equivalent
which means that they mean the same thing.
*)

(*
Anonymous functions are also called lambda expressions,
a term that comes from the lambda calculus, which is a 
mathematical model of computation in the same sense that
uring machiness are a model of ocmputation.
In the lambda calculus, fun x -> e would be written λx.e.
The λ denotes an anonymous function.
*)

(*
Syntax
fun x1 ... xn -> e

Static semantics
If by assuming that x1:t1 and x2:t2 and
xn:tn, we can conclude that e:u, then
fun x1 ... xn -> e : t1 -> t2 -> ... > tn -> u

Dynamic semantics
An anonymous function is already a value. There is no
computation to be performed.
*)

let _ = 
  1 |> inc |> string_of_int |> print_endline;
  1 |> inc2 |> string_of_int |> print_endline;
