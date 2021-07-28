
(* 
OCaml supports labeled arguments to functions.
You can declare this kind of function using the following syntax:
*)
let hello ~name = Printf.sprintf "hello %s" name

(* Labeled arguments can be renamed *)
let hello2 ~name:n = Printf.sprintf "hello %s" n

(*
It is also possible to make some arguments optional.
When called without an optional argument, a default value
will be provided. To declare such a function, 
use the following syntax:

The optional argument must come first.

NOTE:
The argument is not actually optional, it may seem 
optional because it has a default value.
*)
let greet ?to_who:(to_who="world") from_who = Printf.sprintf "hello from %s to %s" from_who to_who

let _ =
  print_endline (hello ~name:"world"); 
  print_endline (hello2 ~name:"world");
  print_endline (greet "john");
  print_endline (greet ~to_who:"bob" "john");