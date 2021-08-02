(*
A ref is like a pointer or reference in an imperative language.
It is a location in memory whose contents may change.
Refs are also called ref cells, the ideia being that
there's a cell in memory that change change.
*)

let _ =
  (* x: int ref *)
  let x = ref 0 in 
    (* ! is the dereference operator *)
    print_endline (string_of_int !x); (* 0 *)

    (* 
    := is the assign operator .
    Note that x itself still points to the same address 
    in memory. Memory is mutable; variable bindings are not.
    *)
    x := !x + 1;

    print_endline (string_of_int !x); (* 1 *)

  (* 
  Aliasing 

  Two refs could point to the same memory location, 
  hence updating through one causes the other to also be updated
  *)
  let x = ref 42 in 
    let y = ref 42 in
      let z = x in 
        print_endline (string_of_int !x); (* 42 *)
        print_endline (string_of_int !y); (* 42 *)
        print_endline (string_of_int !z); (* 42 *)

        x := 43;

        print_endline (string_of_int !x); (* 43 *)
        print_endline (string_of_int !y); (* 42 *)
        print_endline (string_of_int !z); (* 43 *)
