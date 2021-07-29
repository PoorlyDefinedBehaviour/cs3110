(** 
[random_int bound] is a random integer between 
0 (inclusive) and [bound] (exclusive).
Requires: [bound] is greater than 0 and less than 2^30.
*)

(* We wan't to fail fast if user does not respect a precondition *)

let random_int bound =  
  assert (bound > 0 && bound < 1 lsl 30);
  1 (* pretend this is implemented *)
      
let random_int_2 bound =  
  if bound < 0 || bound > 1 lsl 30 then
  (* 
    invalid_arg is a built-in function that
    raises the Invalid_argument exception
  *)
    invalid_arg "bound"
  else
  1 (* pretend this is implemented *)

let random_int_3 bound =  
  if bound < 0 || bound > 1 lsl 30 then
  (* 
    failwith is also a built-in function, but it
    raises a Failure exception instead of Invalid_argument
  *)
    failwith "bound"
  else
  1 (* pretend this is implemented *)

let _ =
  random_int 3 |> string_of_int |> print_endline;
  
  (* raises Fatal error: exception Invalid_argument("bound") *)
  random_int_2 (-1) |> string_of_int |> print_endline;

  (* raises Fatal error: exception Failure("bound") *)
  random_int_3 (-1) |> string_of_int |> print_endline;