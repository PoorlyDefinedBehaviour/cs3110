(*
Lists are immutable. There's no way to change an element
of a list from one value to another. Instead, OCaml programmers
create new lists out of old lists.
*)

(* returns the list if the first element incremented by 1 *)
let increment_first xs =
  match xs with
  | [] -> []
  | head :: tail -> (head + 1) :: tail

(*
Creating new lists out of old ones is not as expensive
as one might think. Since lists are immutable, the compiler
reuses them.
*)

let _ =
  List.iter print_int (increment_first [1; 2; 3])