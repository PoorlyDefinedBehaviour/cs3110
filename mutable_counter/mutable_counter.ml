let counter = ref 0

let next_val = fun () ->
  counter := !counter + 1;
  !counter

let _ =
  print_endline (string_of_int (next_val())); (* 1 *)
  print_endline (string_of_int (next_val())); (* 2 *)
  print_endline (string_of_int (next_val())); (* 3 *)
  