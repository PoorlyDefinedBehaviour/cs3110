(*
Module types let us describe groups of related modules.

The syntax for defining a module type is:

module type ModuleTypeName = sig
  ...
end
*)

(*
By convention, the module type name is capitalized,
but it does not have to be.
*)
module type Stack = sig 
  type 'a stack

  val empty: 'a stack
  val is_empty: 'a stack -> bool
  val push: 'a -> 'a stack -> 'a stack
  val peek: 'a stack -> 'a
  val pop: 'a stack -> 'a stack 
end

exception Operation_not_allowed_on_empty_stack

module Stack: Stack = struct 
  (* 
  The type 'a stack is an example of representation
  type: a type that is used to represent a version 
  of a data structure.
  *)
  type 'a stack = 'a list

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

(*
A structure matches a signature if the structure provides
definitions for all the names specified in the signature,
and these definitions meet the type requirements
given in the signature.
*)

let _ =
  Stack.empty 
  |> Stack.push 1
  |> Stack.push 2
  |> Stack.push 3
  |> Stack.peek
  |> string_of_int
  |> print_endline; (* 3 *)
