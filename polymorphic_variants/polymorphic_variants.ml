(*
Occasionally, you might need a variant type only
for the return value of a single function. For example
heres a function f that can either return an int
or infinity. You are forced to define a variant type
to represent that result:
*)
type fin_or_inf = Finite of int | Infinity

let f = function 
  | 0 -> Infinity 
  | 1 -> Finite 1
  | n -> Finite(-n)

(*
This sucks because we may never actually use 
the type fin_or_inf anywhere else.

There's another kind of variant in OCaml that supports
this kind of programming: polymorphic variants.

Polymorphic variants are just like variants, except:

You don't have to declare their type or constructors
before using them.

There is no name for a polymorphic variant type,
another name for this feature could have been
"anonymous variants".

The constructors of a polymorphic variant start with
`.

Using polymorphic variants, we can rewrite f:
*)
(* f_1: int -> [> `Finite of int | `Infinity 0] *)
let f_1 = function 
  | 0 -> `Infinity 
  | 1 -> `Finite 1
  | n -> `Finite(-n)

let _ =
  let x = 
    match f_1 1 with
      | `Infinity -> "infinity"
      | `Finite x -> string_of_int x
    in 
      print_endline x;

  let x = 
    match f 1 with
      | Infinity -> "infinity"
      | Finite x -> string_of_int x
    in 
      print_endline x;

