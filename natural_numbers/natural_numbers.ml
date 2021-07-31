(* 
A natural number is either zero or 
the successor of some other natural number.
*)
type nat = Zero | Succ of nat

let zero = Zero 
let one = Succ zero 
let two = Succ one 
let three = Succ two 
let four = Succ three

let is_zero = function 
  | Zero -> true
  | Succ _ -> false

let pred = function
  | Zero -> failwith "zero has no predecessor"
  | Succ m -> m

let rec add a b =
  match a with 
  | Zero -> b
  | Succ a_minus_1 -> add a_minus_1 (Succ b)

let rec int_of_nat = function 
  | Zero -> 0
  | Succ n -> 1 + int_of_nat n

let rec nat_of_int n = 
  if n < 0 then failwith "negative ints not allowed"
  else if n == 0 then Zero
  else Succ (nat_of_int (n - 1))

let is_even n = (int_of_nat n) mod 2 = 0

let is_odd n = not (is_even n)

let _ =
  is_zero zero |> string_of_bool |> print_endline;
  one |> pred |> is_zero |> string_of_bool |> print_endline;
  add zero one |> is_zero |> string_of_bool |> print_endline;
  zero |> int_of_nat |> string_of_int |> print_endline;
  add one zero |> int_of_nat |> string_of_int |> print_endline;
  nat_of_int 0 |> is_zero |> string_of_bool |> print_endline;
  nat_of_int 30 |> is_zero |> string_of_bool |> print_endline;
  two |> is_even |> string_of_bool |> print_endline;
  three |> is_even |> string_of_bool |> print_endline;
  two |> is_odd |> string_of_bool |> print_endline;
  three |> is_odd |> string_of_bool |> print_endline;