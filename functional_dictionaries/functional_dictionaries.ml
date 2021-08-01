(*
A dictionary maps keys to values. This data structure
typically supports at least a lookup operation that allows
you to find the value with a corresponding key, an insert
operation that lets you create a new dictionary with an
extra key included. And there needs to be a way of
creating an empty dictionary.
*)

module type Dictionary = sig 
  (* 
  Dictionary.t is parameteried on two types,
  'k and 'v, which are written in parentheses
  and separate by coomas. Although
  ('k, 'v) might look like a pair of values, it is not:
  it is a syntax for writing multiple type variables.
  *)
  type ('k, 'v) t

  val empty: ('k, 'v) t

  val is_empty: ('k, 'v) t -> bool

  val insert: 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t

  val lookup: 'k -> ('k, 'v) t -> 'v option
end

module AssociationListDictionary: Dictionary = struct 
  type ('k, 'v) t = ('k * 'v) list

  (* time O(1) *)
  let empty = []

  (* time O(1) *)
  let is_empty dictionary = dictionary = []

  (* time O(1) *)
  let insert key value dictionary = (key, value) :: dictionary

  (* time O(n) *)
  let lookup key dictionary = List.assoc_opt key dictionary
end

let string_of_opt opt =
  match opt with 
  | None -> "None"
  | Some value -> Format.sprintf "Some(%s)" value

let _ =
  AssociationListDictionary.empty
  |> AssociationListDictionary.insert "foo" "bar"
  |> AssociationListDictionary.lookup "foo"
  |> string_of_opt
  |> print_endline; (* Some(bar) *)