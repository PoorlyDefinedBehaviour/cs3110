(*
The type 'a stack is abstract: The Stack module type
says that there is a type name 'a stack in any module
that implements the module type, but it does not say
what that type is defined to be.
*)
module type Stack = sig 
  type 'a stack

  val empty: 'a stack
  val is_empty: 'a stack -> bool
  val push: 'a -> 'a stack -> 'a stack
  val peek: 'a stack -> 'a
  val pop: 'a stack -> 'a stack 
end

(*
Once we add the : Stack module type annotation, the module
'a stack type also becomes abstract. Outside of the 
module, no one is allowed to know that 'a stack and 'a list
are synonyms.

A module that implements a module type must specify concrete
types for the abstract types in the signature and define
all the names declared in the signature.

Only declarations in the signature are acessible outside
of the module. For example, functions defined in the module's
structure but no in the module type's signature are not
accessible.
*)
module Stack: Stack = struct 
  exception Operation_not_allowed_on_empty_stack
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
In this implementation, we provide our own custom variant
for the representation type. 

Because 'a stack is abstract in the Stack module type,
no client of this data structure will be able to discern
whether stacks are being implemented with the built-in
list type or the custom one we just used. Clients may
only access the stack in the ways that are defined by the
Stack interface, which nowhere mentions list, EMpty
or Entry.
*)
module Stack2: Stack = struct 
  exception Operation_not_allowed_on_empty_stack

  type 'a stack =  
    | Empty 
    | Entry of 'a * 'a stack

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
    | Entry(_, s) -> s
end

(*
Notice how verbose the type Stack.stack is,
the module name already tells us that the value is related
to Stack. The workd stack following that isn't particularly
helpful. For that reason, it is idiomatic OCaml to name
the primary representation type of a data structure simply t.

Here's the Stack module type rewritten that way:

Called Stack_1 to avoid naming conflicts.
*)
module type Stack_1 = sig 
  type 'a t

  val empty: 'a t
  val is_empty: 'a t -> bool
  val push: 'a -> 'a t -> 'a t
  val peek: 'a t -> 'a
  val pop: 'a t -> 'a t 
end

let _ =
  Stack.empty 
  |> Stack.push 1
  |> Stack.push 2
  |> Stack.push 3
  |> Stack.peek
  |> string_of_int
  |> print_endline; (* 3 *)

  Stack2.empty 
  |> Stack2.push 1
  |> Stack2.push 2
  |> Stack2.push 3
  |> Stack2.peek
  |> string_of_int
  |> print_endline; (* 3 *)
