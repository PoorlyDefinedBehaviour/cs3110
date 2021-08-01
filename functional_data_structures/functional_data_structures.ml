(*
A functional data structure is one that does not make use
of any imperative features. That is, no operations of
the data structure have any side effects. 

Functional data structures have the property of being persistent:
updating the data structure with one of its operations
does not change the existing version of the data structure
but instead produces a new version. Both exist and both can 
sill be accessed.

A good implementation will ensure that any parts of the
data structure that are not changed by an operation will be
shared between the old and the new version. Any parts
that do change will be copied so that the old version
may persist.

The opposite of a persitent data structure is an ephemeral
data structure: changes are destructive, so that only one
version exists at any time.
*)

(*
The Stack module is functional: the push and pop operations
do not mutate the underlying list, but instead return a new
list.
*)
module Stack = struct 
  exception Operation_not_allowed_on_empty_stack

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