(*
A function is simply a function from structures to structures.
OCaml is stratified: structures are distinct from values,
so functions from structures to structures cannot be written
or used in the same way as functions from values to value.
But conceptually, functors are really just functions.
*)

module type X = sig 
  val x: int
end

(* 
Example of a functor 

The functor's name is IncX. It's a function from structures
to structures. As a function, it akes an input an produces
and output. Its input is named, and the its type is X.
Its output is the structure that appears on the right-hand side
of the equals sign:
struct let x = M.x + 1 end.
*)
module IncX (M: X) = struct 
  let x = M.x + 1
end

module A = struct 
  let x = 0
end

module B = IncX(A)

module C = IncX(B)

let _ =
  print_endline (string_of_int (A.x)); (* 0 *)
  print_endline (string_of_int (B.x)); (* 1 *)
  print_endline (string_of_int (C.x)); (* 2 *)