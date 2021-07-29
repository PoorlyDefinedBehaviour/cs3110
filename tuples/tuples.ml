(*
A tuple is another kind of type in OCaml that programmers
can define. Like records, it is a composite of other types
of data. But instead of naming the components, they are identified
by position.

Product types huh?

Examples of tuples:

(1, 2, 10)
1,2,3
(true, "Hello")
([1; 2; 3], (0.5, 'X'))

The parentheses are optional

Dynamic semantics

If for all i in 1..n it holds that ei ==> vi, then
(e1, ..., en) ==> (v1, ..., vn)

Static semantics

Tuple types are written using a new type constructor *,
which is different from the multiplication operator.
The type t1 * ... * tn is the type of tuples whose first
component has type t1 ..., and nth component has type tn.

If for all i in 1..n it holds that ei: ti, then
(e1, ..., en): t1 * ... * tn.
*)

(* We can pattern match tuples *)
let f tuple = 
  match tuple with 
  | (a, b, c) -> a + b + c

let _ = 
  (* (1, 2, 3) has type int * int * int *)
  f (1, 2, 3) |> string_of_int |> print_endline;
