(* module Mystack: Mystack = struct ... end is not required *)
type 'a t = 'a list

let empty = []

let is_empty stack = stack = []

let push x stack = x :: stack

let peek stack = 
  match stack with 
  | [] -> None 
  | x :: _ -> Some x

let pop stack = 
  match stack with 
  | [] -> []
  | _ :: tail -> tail