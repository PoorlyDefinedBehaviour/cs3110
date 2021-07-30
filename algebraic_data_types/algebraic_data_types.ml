(*
The shape variant type is defined in terms of
a collection of constructors. 

The constructors carry additional data along them.

Every value of type shape is formed from exactly one
of those constructor. Sometimes we call the constructor a tag,
because it tags the data it carries as being from that
particular constructor.

Variant types are sometimes called tagged unions. 
Every value of the type is from the set of values 
that is the union of all values from the underlying types
that the constructor carries.

Another name for these variant types is an algebraic data
type.

Algebra here refers to the fact that variant types
contain both sum and product types.

The sum types come from the fact that a value of a variant
is formed by one of the constructors.

The product types come from the fact that a constructor
can carry tuples or records, whove values have
a sub-value from each of their component types.

Syntax

To define a variant type:

type t = 
  | C1 [of t1]
  | ...
  | Cn [of tn]

Dynamic semantics

If e ==> v then C e ==> C v, assuming C
is non-costant.

C is already a value, assuming C is a constant.

Static semantics

If t = ... | C ... then C : t.
If t = ... | C of t' : ... and if e : t' then
C e : t.
*)
type point = float * float

type shape = 
  | Point of point
  | Circle of point * float 
  | Rectangle of point * point 

let area = function 
  | Point _ -> 0.0 
  | Circle(_, radius) -> Float.pi *. (radius ** 2.0)
  | Rectangle ((x1, y1), (x2, y2)) ->
      let w = x2 -. x1 in 
      let h = y2 -. y1 in 
        w *. h

type string_or_int =
  | String of string 
  | Int of int

let rec sum = function 
  | [] -> 0
  | (String s) :: tail -> int_of_string s + sum tail
  | (Int i) :: tail -> i + sum tail

let _ =
  Point(2.0, 2.0) |> area |> string_of_float |> print_endline;
  Circle((2.0, 2.0), 5.0) |> area |> string_of_float |> print_endline;
  Rectangle((2.0, 2.0), (3.0, 3.0)) |> area |> string_of_float |> print_endline;

  [String "1"; Int 2] |> sum |> string_of_int |> print_endline;
  
  

