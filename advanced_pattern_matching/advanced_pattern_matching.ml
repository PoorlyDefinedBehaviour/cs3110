(* 
This is an or pattern .
Pattern cases are tried from left to right.
*)
let f x =
  match x with 
  | 1 | 2 | 3 -> "a"
  | 4 -> "b"
  | _ -> "c"

(* Range pattern *)
let is_uppercase_letter char =
  match char with
  | 'A' .. 'Z' -> true
  | _ -> false

(* Pattern with clause *)
let g x = 
  match x with
  | x when x == 10 -> true
  | _ -> false

let _ =
  print_endline (f 1);
  print_endline (f 2);  
  print_endline (f 3);
  print_endline (f 4);
  print_endline (f 5);

  print_endline (string_of_bool (is_uppercase_letter 'a'));
  print_endline (string_of_bool (is_uppercase_letter 'A'));

  print_endline (string_of_bool (g 10));
  print_endline (string_of_bool (g 11));