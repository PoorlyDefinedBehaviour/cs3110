(*
  The following code has an expression in (42)
  but it is not itself an expression. 
  Rather, it is a definition. Definitions
  bind values to names, in this case the value 42
  being bound to the name x.

  Definitions are no expressions, nor are expressions definitions,
  they are distinct syntactic classes. But definitions
  can have expression nested inside them, and vice-versa.
*)
let x = 42

(* Non-recursive functions are defined like this *)
let square x = x * x

(* Recursive functions are defined like normal functions
  but with the rec keyword 
*)
let rec factorial x = 
  if x <= 1 then 1 else x * factorial(x - 1)

(* 
  Note about integers:
  OCaml integers are at least 31 bits, but they could be wider.
  In current implementations, OCaml integers are 63 bits.
  Why 63 instead of 64 bits? The garbage collector needs
  to distinguish between integers and pointers. 
  The runtime repesentation of these therefore steals one bit to flag
  wether a word is an integer or a pointer.
*)

(*
  We don't need to write any types most of the time.
  The OCaml compiler infers them for us automatically.

  Let's imagine we are the compiler and infer the type for
  pow

  Since the if expression can return 1 in the then branch,
  we know by the typing rule if e1 has type bool and e2 has type t and e3 has type t
  then if e1 then e2 else e3 has type t that the entire if expression
  has type int.

  Since the if expression has type in, and the function returns
  the result of the if expression, the function's return type must be int.

  Since y is compared to 0 with equality operator, y must be and int.

  Since x is multiplied with another expression using the * operator, 
  x must be an int.
*)
let rec pow x y =
  if y = 0 then 1 else x * pow x (y - 1)

(* If we wanted to write the types, it would look like this *)
let rec pow2 (x: int) (y: int): int =
  if y = 0 then 1 else x * pow2 x (y - 1)

(* Mutually recursive functions can be defined with the and keyword *)
let rec even n = n = 0 || odd (n - 1)
and odd n = n <> 0 && even (n -1)

let _ = 
  square 2 |> string_of_int |> print_endline;
  factorial 5 |> string_of_int |> print_endline;
  pow 3 2 |> string_of_int |> print_endline;
  pow2 3 2 |> string_of_int |> print_endline;
  even 2 |> string_of_bool |> print_endline;
  even 3 |> string_of_bool |> print_endline;
  odd 2 |> string_of_bool |> print_endline;
  odd 3 |> string_of_bool |> print_endline;
