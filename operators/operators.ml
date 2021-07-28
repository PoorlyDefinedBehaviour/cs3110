let _ =
  (*
  -- Operator overloading --
  OCaml does not support operator overloading.
  As a consequence, the integer and floating-point
  operators are distinct.
  Use + to add integers and +. to add floating-point numbers.
  *)
  print_endline (string_of_int (2 + 2)); (* 4 *)
  print_endline (string_of_float (2.0 +. 2.0)); (* 4.0 *)

  (*
  -- Equality --
  There are two equality operators, = and == with
  corresponding inequality operators <> and !=.
  Operators = and <> examine structural equality whereas
  == and != examine physical equality.
  *)

