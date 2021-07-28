(* 
-- Expressions --
The primary task of computation in a functional language
is to evaluate an expression to a value. A value is an
expression for which there is no computation remaining
to be performed. So, all values are expressions, but no all
expressions are values.
Examples of values: 2, true, "yay!".

Sometimes an expression might fail to evaluate to a value.
There are two reasons for this:
- Evaluation of the expression raises an exception.
- Evaluation of the expression never terminates.
*)

let increment x = x + 1

let _ = 
  print_endline (string_of_int (increment 1))
  