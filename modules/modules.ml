(*
The OCaml module system is based on structures and signatures.

Structures are the core of the module system.

Signatures are the types of structures.

Modules in OCaml are implemented by module definitions
that have the following syntax:

module ModuleName = struct
  ...
end 

Modules are not first-class.
*)

exception Operation_not_allowed_on_empty_stack

(* Module names must begin with an uppercase letter *)
module Stack = struct 
  let empty = []

  let is_empty s = s = []

  let push x s = x :: s

  let peek s =
    match s with 
    | [] -> raise Operation_not_allowed_on_empty_stack
    | x :: _ -> x
  
  let pop s = 
    match s with 
    | [] -> raise Operation_not_allowed_on_empty_stack
    | _ :: xs -> xs
end

let _ =
  Stack.empty 
  |> Stack.push 1
  |> Stack.push 2
  |> Stack.push 3
  |> Stack.peek
  |> string_of_int
  |> print_endline; (* 3 *)
