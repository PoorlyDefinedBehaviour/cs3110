(*
The identity function is the function that simply
returns its input

It has the following type id: 'a -> 'a 
*)
let id x = x
(*
The 'a is a type variable, it stands for an unknown type,
just like a regular variable stands for an unknown value.

Type variables always begin with a single quote.
Commonly used type variables include 'a, 'b and 'c, which
OCaml programmers typically pronounce in Greek: alpha beta and gamma.
*)
let _ = 
(*
  The identity function can be applied to any type because it is
  polymorphic. It can be applied to many(poly) forms(morph).
*)
  print_endline (string_of_int (id 3)); (* prints 3 *)
  print_endline (id "hello world"); (* prints hello world *)
  print_endline (string_of_bool (id true)); (* prints true *)
