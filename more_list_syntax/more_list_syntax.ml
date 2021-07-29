(*
Additional pieces of syntax related to lists and pattern matching.

Immediate matches

When you have a function that immediately pattern matches
against its final argument, there's a nice piece of 
syntactic sugar you can use to avoid writing extra code.
*)
let rec sum xs =
  match xs with
  | [] -> 0
  | head :: tail -> head + (sum tail)

(* 
We could also write sum like this because we immediatell
pattern match against its final argument.

NOTE:
I'm not sure why this exists, writing the parameter name
and the match keyword doesn't seem like a big of a deal.
Maybe it is actually useful in some cases.
*)
let rec sum_2 = function
  | [] -> 0
  | head :: tail -> head + (sum_2 tail)

let _ =
  sum [1; 2; 3] |> string_of_int |> print_endline;
  sum_2 [1; 2; 3] |> string_of_int |> print_endline;
