(*
Since functors are really just parameterized modules,
we can use them to produce functions that are 
parameterized on any structure that matches a signature.
That can help eliminate code duplication.
*)

(*
Example 1

Producing a test suite for multiple structures
*)
module type Stack = sig 
  type 'a t 

  val empty: 'a t

  val push: 'a -> 'a t -> 'a t
  
  val peek: 'a t -> 'a option
end

module ListStack = struct 
  type 'a t = 'a list 

  let empty = []

  let push x stack = x :: stack 

  let peek stack = List.nth_opt stack 0
end

module MyStack = struct 
  type 'a t = 
    | Empty 
    | Entry of 'a * 'a t

  let empty = Empty 

  let push x stack = Entry(x, stack)

  let peek stack = 
    match stack with 
    | Empty -> None 
    | Entry(x, _) -> Some x
end

(*
We are using a functor to avoid duplication when
trying to test different implementations of the
Stack signature.
*)
module StackTester (S: Stack) = struct 
  assert (S.(empty |> push 1 |> peek) = Some(1));
end

module ListStackTester = StackTester(ListStack)
module MyStackTester = StackTester(MyStack)

let _ =
  print_endline "hello world";
 