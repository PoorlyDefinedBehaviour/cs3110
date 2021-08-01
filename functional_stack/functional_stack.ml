module type Stack = sig 
  type 'a t

  val empty: 'a t

  val is_empty: 'a t -> bool

  val push: 'a -> 'a t -> 'a t

  val peek: 'a t -> 'a

  val pop: 'a t -> 'a t
end

module ListStack: Stack = struct 
  exception Operation_not_allowed_on_empty_stack

  type 'a t = 'a list

  let empty = []

  let is_empty s = s = []

  let push x s = x :: s 

  let peek s = 
    match s with 
    | [] -> raise Operation_not_allowed_on_empty_stack
    | head :: _ -> head

  let pop s = 
    match s with 
    | [] -> raise Operation_not_allowed_on_empty_stack
    | _ :: tail -> tail
end

module MyStack: Stack = struct 
  exception Operation_not_allowed_on_empty_stack

  type 'a t = 
    | Empty 
    | Entry of 'a * 'a t

  let empty = Empty 

  let is_empty s = s = Empty

  let push x s = Entry(x, s)

  let peek s = 
    match s with 
    | Empty -> raise Operation_not_allowed_on_empty_stack
    | Entry(x, _) -> x

  let pop s = 
    match s with 
    | Empty -> raise Operation_not_allowed_on_empty_stack
    | Entry(_, tail) -> tail
end

(* 
Both stack implementations are functional because 
they never destroy the previous version of the structure.
*)
let _ =
  ListStack.empty 
  |> ListStack.push 1
  |> ListStack.push 2
  |> ListStack.push 3
  |> ListStack.peek
  |> string_of_int
  |> print_endline; (* 3 *)

  MyStack.empty 
  |> MyStack.push 1
  |> MyStack.push 2
  |> MyStack.push 3
  |> MyStack.peek
  |> string_of_int
  |> print_endline; (* 3 *)