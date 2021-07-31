(*
Construct a list that has the integers 1 through 5 in it.
Use the square bracket notation for lists.
*)
let xs = [1; 2; 3; 4; 5]

(*
Construct the same list,
but do not use the square bracket notation.
Instead use :: and [].
*)
let ys = 1 :: 2 :: 3 :: 4 :: 5 :: []

(*
Construct the same list again.
This time, the following expression must appear in your answer:
[2;3;4]. Use the @ operator, and do not use ::.
*)
let zs = [1; 2] @ [2; 3; 4]

(*
Write a function that returns the product of 
all the elements in a list.
The product of all the elements of an empty list is 1.
*)
(* 
time O(n) 
space O(1)
*)
let product xs = 
  let rec go acc xs = 
    match xs with
    | [] -> acc
    | head :: tail -> go (acc * head) tail
  in go 1 xs

(*
Write a function that concatenates all the strings in a list.
The concatenation of all the strings in an 
empty list is the empty string "". 
*)
let join xs =
  let rec go acc xs =
    match xs with 
    | [] -> acc
    | head :: tail -> go (acc ^ head) tail
  in go "" xs

let take n xs = 
  let rec go acc taken xs =
    match xs with 
    | [] -> acc
    | head :: tail -> 
        if taken == n then 
          acc 
        else 
          go (head :: acc) (taken + 1) tail
  in 
    List.rev (go [] 0 xs)

(*
Write a function that returns the last element of a list.
Your function may assume that the list is non-empty. 
*)
let last xs = List.hd (List.rev xs)

let last_2 xs = List.nth xs (List.length xs - 1)

(*
Write a function take : int -> 'a list -> 'a list 
such that take n lst returns the first n elements of lst.
If lst has fewer than n elements, return all of them. 
*)
(*
time O(n)
space O(1)
*)
let drop n xs =
  let rec go xs dropped =
    match xs with
    | [] -> xs
    | _ :: tail -> 
        if dropped = n then 
          xs
        else 
          go tail (dropped + 1) 
  in 
    go xs 0 

let _ =
  List.length xs |> string_of_int |> print_endline;
  List.length ys |> string_of_int |> print_endline;
  List.length zs |> string_of_int |> print_endline;
  product [1; 2; 3; 4; 5] |> string_of_int |> print_endline;
  join ["hello"; " "; "world"] |> print_endline;
  join [] |> print_endline;
  take 5 [1; 2; 3; 4; 5; 7; 8; 9; 10] |> product |> string_of_int |> print_endline;
  last [1; 2; 3] |> string_of_int |> print_endline;
  last_2 [1; 2; 3] |> string_of_int |> print_endline;
  drop 1 [1; 2; 3; 4; 5] |> List.hd |> string_of_int |> print_endline;