(*
The standard library's Map module, which implements
a dictionary data structure using balanced binary trees,
is based on functors.

The Map module defines a functor Make that creates a structure
implementing a map over a particular type of keys.
That type is the input structure to Make. The type
of that input structure is Map.OrderedType,
which are types that support a compare operatio:

-- From the standard library --

module type OrderedType = sig
  type t
  val compare: t -> t -> int
end
---

The Map moduleneeds ordering because balance binary trees
need to be able to compare keys to determine whether one is
greater than another.

The output of Map.Make is a structure whose type is (almost) Map.S 
and supports all the usual operations we would expect from
a dictionary.
*)
module IntMap = Map.Make(struct 
  type t = int 
  let compare = Stdlib.compare
end)

let _ =
  IntMap.empty 
  |> IntMap.add 1 "hello"
  |> IntMap.find 1
  |> print_endline;

  