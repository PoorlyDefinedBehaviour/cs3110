(*
A variant is a data type representing a value that is one of
several possibilities. At their simplest,
variants are like enums from C or Java:

The individual names of the values of a variant are
called constructors in OCaml.

Syntax

type t = C1 | ... | Cn

The constructor name must begin with an uppercase letter.
OCaml uses that to distinguish constructors from variable
identifiers.

Dynamitc semantics

A constructor is already a value. There is no computation
to perform.

Static semantics

If t is a type defined as type t = ... | C | ... then
C : t
*)
type day = 
  Sunday
  | Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday

(*
Note: is there a ppx to derive it 
if ocaml can't derive by default?
*)
let string_of_day d =
  match d with 
  | Sunday -> "Sunday"
  | Monday -> "Monday"
  | Tuesday -> "Tuesday"
  | Wednesday -> "Wednesday"
  | Thursday -> "Thursday"
  | Friday -> "Friday"
  | Saturday -> "Saturday"

let _ =
  let d: day = Wednesday in
    print_endline (string_of_day d)