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


module Ints: Arith = struct 
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