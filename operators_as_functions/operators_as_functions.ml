(*
The addition operator + has type int -> int -> int.
It is normally written infix, e.g., 3 + 4.
By putting parentheses around it, we can make it a prefix operator:

(+): int -> int -> int = <fun>

The same technique works for any built-in operator.
*)

(* inc: int -> int *)
let inc = (+) 1

(* We can even define our own new infix perators *)
let (^^) x y = max x y

let _ =
  print_endline (string_of_int ((+) 3 4)); (* prints 7 *)
  print_endline (string_of_int (inc 1)); (* prints 2 *)
  print_endline (string_of_int (2 ^^ 3)); (* prints 3 *)