(*
After a module M has been defined, you can access
the names within it using the . operator.
*)
module M = struct 
  let x = 42
end

(* 
You can also bring all of the definitions of a module
into scope using open ModuleName.
*)
open M

(*
Opening a module is like writing a local definition for each 
name defined in the module.

open String for example, brings all the definitions from
the String module into scope, and has an effect similar
to the following on the local namespace:
*)
let length  = String.length
let get = String.get 
let lowercase_ascii = String.lowercase_ascii

(*
If there are types, exceptions, or modules defined in an module, 
those also are brought into scope with open.

For example, if we're given this module:
*)
module K = struct 
  let x = 42 

  type t = bool 

  exception E 

  module N = struct 
    let y = 0
  end
end
(* 
Then open K would have an effect similar to the following:

let x = K.x

let t = K.t

exn is an extensible variant, here we are extending the 
type exn.

exception NameOfException is syntactic sugar for
type exn += NameOfException 

type exn += E = K.E

module N = K.N
*)

(*
If we open two or more modules that define the same
names, the names defined later shadow names defined earlier.

Example:
module A = struct 
  let value = 42
end

module B = struct 
  let value = "hello world"
end

open A
value is 42 at the moment

open B
value is "hello world" at the moment
*)

(*
We can open modules inside expressions, such that the module's
names are in scope only in the rest of the expression.
*)
let range n = 
  let open List in 
    init n succ
  
(* 
There is a syntatic sugar for let open ModuleName in: ModuleName.(expression)

Example:
*)
let s = String.(" Hello World" |> trim |> lowercase_ascii)

let pp_list xs = "[" ^ String.concat "; " (List.map string_of_int xs) ^ "]"

let _ =
  print_endline (string_of_int M.x); (* 42 *)

  print_endline (string_of_int x); (* 42 *)

  print_endline (pp_list (range 5)); (* [1; 2; 3; 4; 5] *)

  print_endline s; (* hello world *)
  