(*
We can build recursive functions without ever using
the keyword rec.

fact0 points to fact so we are recursing without the rec keyword.
*)
let fact0 = ref (fun x -> x)

let fact n = 
  if n <= 1 then 
    1 
  else 
    n * !fact0 (n - 1)

let () = fact0 := fact

let _ =
  print_endline (string_of_int (fact 5));