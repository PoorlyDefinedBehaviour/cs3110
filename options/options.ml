(*
Option is useful when you have functions that may
or not return a value. In other languages like java you
would use null and in Go you would also use null,
but a different null for each type because Go thought it
was a good idea.

The option monad is also known as maybe.

OCaml options force the programmer to
include a branch in the pattern match for None, 
thus guaranteeing that the programmer thinks about
the right thing to do when there's nothing there.

So we can think of options as a principled way of
eliminating null from the language.

Syntax and semantics
t option is a type for every type t like t list.

None if a value of type 'a option.

Some e is an expression of type t option if 
e: t. If e ==> v then Some e ==> Some v
*)

(* 
We are using option here because we don't have a value to
return when the list if empty
*)
let rec list_max xs = 
  match xs with
  | [] -> None
  | head :: tail -> 
    match list_max tail with 
      | None -> Some head
      | Some new_max -> Some (max head new_max)

let value_as_string opt =
  match opt with 
  | None -> "list is empty"
  | Some value -> string_of_int value

let _ =
  print_endline (value_as_string (list_max [1; 2; 3; 4; 5]));
  
