(*
Fold left is the same as fold right but evaluation
goes from left to right.

It is called List.fold_left in the OCaml library.

The evaluation for
fold_left (+) 0 [1; 2; 3] will look like this:

((0 + 1) + 2) + 3)

where evaluation will begin from left to right.
*)
let rec fold_left op acc = function 
  | [] -> acc
  | head :: tail -> op head (fold_left op acc tail)

let sum = fold_left (+) 0

let _ =
  sum [1; 2; 3] |> string_of_int |> print_endline