(*
An OCaml list is a sequence of values all of which have the 
same type. They are implemented as singly-linked lists.
These lists enjoy a first-class status in the language:
there is special support for easily creating and working with
lists.

Syntax
There are three syntactic forms for building lists:

[]
e1 :: e2
[e1; e2; ...; en]

The empty list is written [] and is pronounced "nil",
a name that comes from Lisp.

Given list lst and a element elt, we can prepend elt to lst 
by writing elt::lst. The double-colon operator is pronounced "cons"
also form lisp.

The [e1; e2; ...; en] is syntax sugar for
e1 :: e2 :: ... :: en :: []

Dynamic semantics
[] is already a value.
If e1 evalalutes to v1, and if e2 evaluates to v2,
then e1 :: e2 evaluates to v1 :: v2.

Static semantics
All the elements of a list must have the same type.

If that element type is t, then the type of the list is t list.

The word list is not a type: there is no way to build
an OCaml value that has type simply list.
Rather, list is a type constructor: given a type,
it produces a new type.
For example, given int, it produces the type int list.

You could think of type constructors as being like functions
that operate on types.

Type-checking rules
[]: 'a list
if e1: t and e2: t list then e1 :: e2 : t list

[] has type 'a list because the empty list is a list whose
element have an unknown type. 

If we cons something onto the empty list, the compiler
will then infer its type.

2 :: [] has type int list 
true :: [] has type bool list
*)
let _ =
  print_endline "Hello world"
