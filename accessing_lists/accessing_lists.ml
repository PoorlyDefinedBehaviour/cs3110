(*
There are only two ways to build a list, with nil and cons.
So if we want to take apart a list into its component pices,
we have to say what to do with the list if it isempty,
and what to do if it is non-empty.

We can do that with pattern matching.
*)
let rec sum xs =
  match xs with
  | [] -> 0
  | head :: tail -> head + sum tail

let rec length xs = 
  match xs with
  | [] -> 0
  | _ :: tail -> 1 + length tail

(* append is available as the built-in operator @ *)
let rec append xs ys =
  match xs with
  | [] -> ys
  | head :: tail -> head :: (append tail ys)

let empty xs = 
  match xs with 
  | [] -> true
  | _ -> false

(* we can write empty without pattern matching *)
let empty_2 xs = xs = []

(*
Note how all the recursive functions above are similar to
doing proofs by induction on the natural numbers:
every natural number is either 0 or is 1 greater than
some other natural number n, and so a proof by induction has 
a base case for 0 and an inductive case for n +1.
Likewise all our functions have a base case for the empty list
and a recursive case for the list that has one more element
than another list. This similarity is no accident, there is 
a deep relationship between induction and recursion.
*)

let _ =
  sum [1; 2; 3] |> string_of_int |> print_endline;

  length [1; 2; 3] |> string_of_int |> print_endline;

  append [1; 2; 3] [4; 5; 6] |> sum |> string_of_int |> print_endline;

  [1; 2; 3] @ [4; 5; 6] |> sum |> string_of_int |> print_endline;

  empty [] |> string_of_bool |> print_endline;
  empty [1] |> string_of_bool |> print_endline;
  
  empty_2 [] |> string_of_bool |> print_endline;
  empty_2 [1] |> string_of_bool |> print_endline;

  (* will raise when list if empty *)
  List.hd [1; 2; 3] |> string_of_int |> print_endline;
  List.tl [1; 2; 3] |> sum |> string_of_int |> print_endline;
  
