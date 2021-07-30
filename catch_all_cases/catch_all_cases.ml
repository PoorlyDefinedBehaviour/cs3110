type color = Blue | Red 

(*

This is bad because when we add another color
and forget to update this function, the compiler
will not warn us.

This is called a catch-all case and is considered
bad practice.
*)
let string_of_color = function 
  | Blue -> "blue"
  | _ -> "red" (* this pattern matches anything *)

let _ =