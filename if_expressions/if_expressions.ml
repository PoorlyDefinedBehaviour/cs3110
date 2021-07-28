let _ =
  (* 
    The expression if e1 then e2 else e3 evaluates
    e2 if e1 evaluates to true, otherwise e3.
    We call e1 the guard of the if expression.

    Unlike if-then-else statements, if-then-else expressions
    in OCaml are just like any other expression.
    They can be put anywhere an expression can go,
    that makes them similar to the ternary operator ? : 
    in other languages.
  *)
  print_endline (if 3 + 5 > 2 then "yay!" else "boo!")

  (*
    The syntax of an if expression:

    if e1 then e2 else e3

    The letter e is used to represent any OCaml expression.
    It's an example of a metavariable, which is not actually
    a variable in the OCaml language itsell, but instead
    a name for a certian syntactic construct.

    The dynamic semantics of an if expression:

    if e1 evaluates to true, and if e2 evaluates to a 
    value v, then if e1 then e2 else e3 evaluates to v.

    if e1 evaluates to false, and if e3 evaluates to a
    value v, then if e1 then e2 else e3 evaluates to v.

    The static semantics of an if expression:

    if e1 has type bool and e2 has type t and e3 has type t
    then if e1 then e2 else e3 has type t. (getting Types and programming languages vibes)

    We call this a typing rule: it describes how to type check an expression.
  *)