(*
The fields of a record can be declared as mutable,
meaning their contents can be updated without 
constructing a new record.

Syntax

e1.f <- e2

Dynamic semantics

To evaluate e1.f <- e2, evaluate e2 to a value v2,
and e1 to a value v1, which must have a field named f.
Updated v1.f to v2. Return ().

Static semantics

e1.f <- e2: unit if e1: t1 and t1 = {...; mutable f: t2; ...},
and e2: t2.
*)
type point = {
  x: int;
  y: int;
  (* 
  Note that mutable is a property of the field,
  rather than the type of the field.
  *)
  mutable c: string;
}

let _ =
  let p = { x = 0; y = 0; c = "red"} in 

  print_endline p.c; (* red *)

  (* The operator to update a mutable field is <- *)
  p.c <- "white";

  print_endline p.c; (* white *)
