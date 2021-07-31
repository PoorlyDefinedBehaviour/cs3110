let sum_squares n = 
  let rec loop i sum =
    if i > n then 
      sum 
    else loop 
      (i + 1) (sum + i * i)
  in 
    loop 0 0

(* 
Same as above.

This version is more readable but
traveses a list three times and uses more memory
while sum_squares is O(1) space,
its ok though.
*)
let sum_squares_2 n =
  List.init n succ (* [0;1;2;...;n] *)
  |> List.map (fun x -> x * x)
  |> List.fold_left (+) 0

let _ =
  sum_squares 5 |> string_of_int |> print_endline;
  sum_squares_2 5 |> string_of_int |> print_endline;