(*
Variant types may mention their own name inside
their own body.
*)
type 'a mylist = Nil | Cons of 'a * 'a mylist

let rec sum = function 
  | Nil -> 0
  | Cons(head, tail) -> head + sum tail

let rec length = function
  | Nil -> 0
  | Cons(_, tail) -> 1 + length tail

let empty = function
  | Nil -> true
  | Cons _ -> false

(*
Types may be mutually recursive if you use the and keyword
just like functions.
*)
type node = {
  value: int;
  next: mylist_1;
}
and mylist_1 = Nil1 | Node of node

let _ =
  Cons(1, Cons(2, Cons(3, Nil))) |> sum |> string_of_int |> print_endline;
  Cons(1, Cons(2, Cons(3, Nil))) |> length |> string_of_int |> print_endline;
  Cons(1, Cons(2, Cons(3, Nil))) |> empty |> string_of_bool |> print_endline;
  Nil |> empty |> string_of_bool |> print_endline;