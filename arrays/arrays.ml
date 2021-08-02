(*
Arrays are fixed-length mutable sequences with constant-time
access and update.
*)

let _ =
  (* The syntax for arrays is similar to lists *)
  let v = [|0; 1|] in

  (* Arrays can be mutated using the <- operator like mutable record fields *)
  v.(0) <- 3;

  print_endline (string_of_int v.(0)); (* 3 *)
  