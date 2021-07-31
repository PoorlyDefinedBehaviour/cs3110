(*
The map functional(higher-order function) give us a way to 
transform each element of a list. The filter functional gives
us a way to individually decide wether to keep or throw
away each element of a list. But both of those are really
just looking at a single eleemnt at a time. What if we wanted
to somehow combine all the elements of a list?
*)

(* Example functions *)
let rec sum = function
  | [] -> 0
  | head :: tail -> head + sum tail

let rec concat = function 
  | [] -> ""
  | head :: tail -> head ^ concat tail

(* 
The function is called fold_right because of the way
expressions are evaluated.

Because of the recursion, the evaluation for
fold_right (+) [1; 2; 3] 0 will look like this:

(1 + (2 + (3 + 0)))

where the evaluation will begin from right to left
because of the most nested parentheses.
*)
let rec fold_right f xs zero = 
  match xs with 
  | [] -> zero 
  | head :: tail -> f head (fold_right f tail zero)

let sum_2 xs = fold_right (+) xs 0

let concat_2 xs = fold_right (^) xs ""

let _ =
  sum [1; 2; 3] |> string_of_int |> print_endline;
  concat ["hello"; " "; "world"; "!"] |> print_endline;
  sum_2 [1; 2; 3] |> string_of_int |> print_endline;
  concat_2 ["hello"; " "; "world"; "!"] |> print_endline;