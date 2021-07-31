(*
Consider writing a function lst_and: bool list -> bool,
such that lst_and [a1; ...; an] returns wether all elements
of the list are true. That is, it evaluates the same as 
a1 && a2 && .. && an. When applied to an empty list,
it evaluates to true.
*)

(* 
time O(n)
space O(n)

short circuits when head evaluates to false
*)
let rec lst_and_rec = function 
  | [] -> true 
  | head :: tail -> head && lst_and_rec tail

(* 
time O(n)
space O(1)

never short circuits, always processes the whole list
*)
let lst_and_fold = List.fold_left(fun acc boolean -> acc && boolean) true


(*
time O(n)
space O(1)

short circuits if any element evaluates to false
*)
let lst_and_lib = List.for_all (fun x -> x)

let _ =
  [true; true; true] |> lst_and_rec |> string_of_bool |> print_endline;
  [true; false; true] |> lst_and_rec |> string_of_bool |> print_endline;

  [true; true; true] |> lst_and_fold |> string_of_bool |> print_endline;
  [true; false; true] |> lst_and_fold |> string_of_bool |> print_endline;

  [true; true; true] |> lst_and_lib |> string_of_bool |> print_endline;
  [true; false; true] |> lst_and_lib |> string_of_bool |> print_endline;
