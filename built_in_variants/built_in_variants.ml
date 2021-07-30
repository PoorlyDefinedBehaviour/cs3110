(*
Lists

OCaml's built-in list data type is really a recursive,
parameterized variant. It is defined as follows:

type 'a list = [] | :: of 'a * 'a list

Options

OCaml's built-in option data type is really a parameterized
variant. It's defined as follows:

type 'a option = None | Some of 'a
*)
let _ =
  print_endline "hello world"