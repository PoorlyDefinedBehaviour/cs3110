(*
OCaml has built-in printing functions for several of the
built-in primitive types: print_char, print_int,
print_string, and print_float. There's also a
print_endline function, which is like print_string,
but also outputs a newline.

Let's look at their types:

print_endline: string -> unit

print_string: string -> unit

They both take a string as input and return a value of type
unit. There is only one value of this type,
which is written () and also pronounced "unit".
So unit is like bool, except there one fewer value of type
unit than there is of bool.

Unit is used when you need to take an argument
or return a value, but there's no interesting value to pass
or return. 

Unit is often used when you're writing or 
using code that has side effects. 
Printing is an example of an side effect.
*)
let _ = 
  print_endline "hello world";
  print_endline "hello world";
  print_string "!";

  (* The code above is syntax sugar for this *)

  let _ = print_endline "hello world" in
    let _ = print_endline "hello world" in
      print_string "!";

  (*
    e1; e2 first values e1, which sould evaluate to (),
    then discards that value, and evaluates e2.

    If e1 does not have type unit, then e1;e2 will give a warning,
    if you really want to do this, you can use the built-in
    function ignore: 'a -> unit to convert any value to ()
    
  *)
  ignore 2
