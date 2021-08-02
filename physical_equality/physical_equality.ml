(*
OCaml has two equality operators, physical equality and
structural equality.

e1 Stdlib.(==) e2 tests for physical equality of e1 and e2.
On mutable types such as references, arrays, byte sequences,
records with mutable fields and object with mutable instance
variables, e1 == e2 is true if and only if physical modification
of e1 also effects e2. On non-muttable types, the behaviour of
== is implementation dependent; however, it is guaranteed
that e1 == e2 implies compare e1 e2 = 0.
*)
let r1 = ref 3110

let r2 = ref 3110

let _ =
  print_endline (string_of_bool (r1 == r1)); (* true *)
  print_endline (string_of_bool (r1 == r2)); (* false *)
  print_endline (string_of_bool (r1 != r2)); (* true *)
  print_endline (string_of_bool (r1 = r1)); (* true *)
  print_endline (string_of_bool (r1 = r2)); (* true *)
  print_endline (string_of_bool (r1 <> r2)); (* false *)
  print_endline (string_of_bool (ref 3110 <> ref 2110)); (* true *)