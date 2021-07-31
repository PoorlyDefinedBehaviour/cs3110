(* Here are two functions we might want to write *)
let even n = n mod 2 = 0
let odd n = not (even n)

let rec evens = function 
  | [] -> []
  | head :: tail -> 
    if even head then 
      head :: evens tail
    else 
      evens tail

let rec odds = function
  | [] -> []
  | head :: tail ->
    if odd head then 
      head :: odds tail 
    else 
      odds tail
(* 
The only difference between these functions is the predicate
they apply to the head of the list to decide if the element
should be kept in the list that will be returned.

Let's create a function that takes the predicate and the list as 
arguments.
*)

(* OCaml standard library calls it List.filter *)
let rec filter predicate = function 
  | [] -> []
  | head :: tail ->
    if predicate head then
      head :: filter predicate tail
    else
      filter predicate tail

let evens_2 = filter even
let odds_2 = filter odd

let pp_list xs = "[" ^ String.concat "; " (List.map string_of_int xs) ^ "]"

let _ =
  let xs = [1; 2; 3; 4; 5] in 
    xs |> evens |> pp_list |> print_endline; (* [2; 4]  *)
    xs |> odds |> pp_list |> print_endline; (* [1; 3; 5] *)
    xs |> evens_2 |> pp_list |> print_endline; (* [1; 3; 5] *)
    xs |> odds_2 |> pp_list |> print_endline; (* [1; 3; 5] *)
  