(*
A compilation unit is a pair of OCaml source files in
the same directory. They share the same base name, call it 
x, but their extenssions differ: one file is x.ml, the
other ir x.mli. The file x.ml is called the implementation,
and x.mli is called the interface.

For example, suppose that foo.mli contains exactly the following:

val x: int 
val f: int -> int -> Int

and foo.ml, in the same directory, contains exactly the following:

let x = 0
let y = 12
let f x y = x + y

Then compilling foo.ml will have the same effect as
defining the module Foo as follows:

module Foo: sig 
  val x: int 
  val f: int -> int -> int
end = struct 
  let x = 0
  let y = 12
  let f x y = x + y
end

The unit name Foo is derived from the base name foo by just
capitalizing the first letter. Notice that there
is no named module type being defined; the signature
of Foo is actually anonymous.

Check the other files in this folder for a example.
*)
let string_of_opt opt = 
  match opt with 
  | None -> "None"
  | Some value -> Format.sprintf "Some(%d)" value

let _ =
  Mystack.empty 
  |> Mystack.push 1
  |> Mystack.push 2
  |> Mystack.push 3
  |> Mystack.peek
  |> string_of_opt
  |> print_endline; (* Some(3) *)