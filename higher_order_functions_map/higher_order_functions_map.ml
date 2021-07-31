(* 
The idea of mapping something is to transform whatever
elements are inside a structure without modifying the structure.
*)
(* Take these two functions for example *)
let rec add1 = function
  | [] -> []
  | head :: tail -> (head + 1) :: add1 tail

let rec concat3110 = function 
  | [] -> []
  | head :: tail -> (head ^ "3110") :: concat3110 tail

(* 
The only real difference between these functions is that
they apply a different function when transforming the
head element.

So lets abstract that function from the definitions of
add1 and concat3110, and make it an argument. 
Call the unified version of two map, because it maps
each element of the list through a function.
*)

(* The OCaml standard library calls it List.map *)
let rec map f = function
  | [] -> []
  | head :: tail -> (f head) :: map f tail

let add_1_2 = map ((+) 1)

let concat3110_2 = map (fun x -> x ^ "3110")

let _ =
  add_1_2 [1; 2; 3] |> List.hd |> string_of_int |> print_endline;
  add_1_2 [1; 2; 3] |> List.hd |> string_of_int |> print_endline;
  concat3110_2 ["a "; "b "; "c "] |> List.hd |> print_endline;