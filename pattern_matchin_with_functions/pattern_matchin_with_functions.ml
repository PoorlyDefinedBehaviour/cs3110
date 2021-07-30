(*
This is the full syntax for functions that OCaml permits:

Static semantics

Let x1..xn be the pattern variables apperaing in p.
If by assuming that x1: t1 and x2: t2 and
xn: tn, we can conclude that p: t and e: u,
then fun p -> e : t -> u

Dynamic semantics

To evaluate e0 e1

Evaluate e0 to an anonymous function fun p -> e
and evaluate e1 to v1

Match v1 against pattern p. If it doesn't match,
raise the exception Match_failure.
Otherwise, if it does match, it produces a set b of bindings.

Substitute those bindings in e, yield a new expression e'.

Evalute e' to a value v, which is the result
of evaluating e0 e1.
*)

(* let f p1 ... pn = e *)
let square x = x * x

(* fun p1...pn -> e *)
let increment = fun x -> x + 1

let _ =
  square 2 |> string_of_int |> print_endline;

  increment 1 |> string_of_int |> print_endline;

  (* let f p1 ... pn = e1 in e2 *)
  let double = ( * ) 2 in 
    print_endline (string_of_int (double 2));