(*
Sometimes you actually want to expose the type in an 
implementation of a module. You might like to say the 
module A implements B and the type t is int, and allow
external users of the module to use the fact that
t is int.

OCaml lets you write sharing constraints that refine
a signature by specifying equations that must hold
on the abstract types in that signature. If T is a module type
containing an abstract type t, then T with type t = int
is a new module type that is the same as T, except that
t is known to be int.

Example:
*)
module type Arith = sig 
  type t 
  
  val zero: t 
  
  val one: t 

  val ( + ): t -> t -> t 

  val ( * ): t -> t -> t 

  (* Unary negation operator *)
  val ( ~- ): t -> t

  val to_string: t -> string
end


module Ints: (Arith with type t = int) = struct 
  type t = int 

  let zero  = 0

  let one = 1

  let ( + ) = Stdlib.( + )

  let ( * ) = Stdlib.( * )

  let ( ~- ) = Stdlib.( ~- )

  let to_string = string_of_int
end

let _ =
  print_endline (Ints.(to_string (one + one))); (* 2 *)

  (*
  This wouldn't work without (Arith with type t = int)
  in the Ints module declaration because Arith.t is abstract
  and the client wouldn't know that the t is int.
  *)
  print_endline (Ints.(to_string (1 + 1))); (* 2 *)