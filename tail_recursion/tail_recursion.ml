(*
A function is tail recursive if it calls itself recursively
but does not perform any computation after the recursive call
returns, and immediately returns to its caller the value of
its recursive call.
*)

(* 
This function is not tail recursive because
there's the + operator after the recursive call to sum
returns in the | head :: tail -> x + (sum tail) pattern.
*)
let rec sum xs =
  match xs with 
  | [] -> 0
  | head :: tail -> head + (sum tail)

let rec sum_tail_recursive_impl accumulator xs = 
  match xs with 
  | [] -> accumulator
  | head :: tail -> sum_tail_recursive_impl (accumulator + head) tail

(* 
This function is tail recursive because
the helper function performs no computation after its recursive
calls return.
*)
let sum_tail_recursive = sum_tail_recursive_impl 0

(*
Why we care about tail recursion

Function languages like OCaml and even some imperative languages
like C++ typically include an hugely useful optimization:

when a call is a tail call, the caller's stack-frame is popped
before the call -- the callee's stack-frame just replaces the caller's.

With this optimization, recursion can sometimes be as efficient as a while loop
in imperative languages(such loops don't make the call-stack bigger).
Sometimes is exactly when calls are tail calls.

With tail-call optimization, the space performance of a recursive 
algorithm can be reduced from O(n) to O(1), that is,
from one stack frame per call to a single stack frame for all calls.
*)

let _ =
  sum [1; 2; 3] |> string_of_int |> print_endline;
  sum_tail_recursive [1; 2; 3] |> string_of_int |> print_endline;