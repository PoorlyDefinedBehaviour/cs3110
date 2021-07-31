(*
Part of being an excellent programmer is recognizing
similarities and abstracting them by reating functions
or other units of code tha implement them.

This is known as the Abstraction Principle, which says
to avoid requiring something to be stated more than once.
Instead, factor out the recurring pattern.

Higher-order functions is one of the tools that enable such
refactoring, because they allow us to factor out functions
and parameterize functions on other functions.
*)
(* Reusing functions *)
let apply f x = f x

let pipeline x f = f x

(* The pipe operator is already in the language *)
let ( |> ) = pipeline

let double = ( * ) 2

(* Composing functions *)
let compose f g x = f (g x)

let ( >> ) = fun f g x -> compose g f x

let square x = x * x

let square_then_double = compose double square

let square_then_double_2 = square >> double

let both f g x = (f x, g x)

let fst (x, _) = x

let cond predicate consequence alternative x = 
  if predicate x then 
    consequence x
  else 
    alternative x

let is_even x = x mod 2 = 0

let _ =
  let x = 5 |> double in 
    x |> string_of_int |> print_endline;

  let x = square_then_double 2 in 
    x |> string_of_int |> print_endline;
  
  let x = square_then_double_2 2 in 
    x |> string_of_int |> print_endline;

  both square double x |> fst |> string_of_int |> print_endline;

  let x = cond is_even string_of_int (fun _ -> "not even") 2 in 
    print_endline x;
