(*
OCaml has an exception mechanism similar to many
other programming languages.
A new type of OCaml exception is defined with this syntax:

exception E of t where E is a constructor name and t
is a type. The of t is optional.

Exceptions are exten sible variants

All exception values have type xn, which is a variant
define in the core library. It's an unusual kind of variant,
though, called an extensible variant, which allows
new constructors of the variant to be defined after the variant
type itself is defined.

So when we declare a new exception, we are in fact,
declaring a constructor of the exn variant.

Dynamic semantics

Every OCaml expression either

- Evaluates to a value
- Raises an enception
- Or fails to terminate

With exceptions, the evaluation of an OCaml expression either 
produces a value of an exception packet.

Packets are not normal OCamlvalues, the only pieces of the language
that recognizes them are raise and try.

For any expression e other than try, if evaluation of a
subpexpression of e produces an exception packet P,
then evaluation of e produces packet P.

Evaluation order

exception A
exception B

let x = raise A in raise B

A is raised because the binding expression must be evaluated
before the body expression.

(raise A) (raise B)

A is raised because function application is evaluated left to right.

Special case

(raise A, raise B)

The language specification does not stipulate what order the components
of pairs should be evaluated in. The current implementation of
OCaml, actually evaluates right to left, so the code above would
raise B.

exception C of string
exception D of string 

raise (C (raise D "oops"))

The code ends up raising D, because it is the first exception
to be raised.
*)
exception Unwrap_called_on_none

exception Argument_not_found of string

exception Something_went_wrong

let function_that_may_throw = function 
  | 0 -> raise Something_went_wrong
  | _ -> 1

let _ =
  (* To raise an exception value e, simply write: *)
  raise (Argument_not_found "oops");

  (*
  There is a convenient functon failwith: string -> 'a in the
  standard library that raises Failure. That is, failwith s
  is equivalent to raise (Failure s)
  *)
  failwith "oops";

  (* 
  If e does not raise an exception, the entire
  try expression evaluates to whatever e does.
  If e does raise an exception value 
  v, that value v is matched against the provided
  pattern, exactly like a match expression.
  

  To catch an exception, use this syntax: 
  *)
  let x = 
    try function_that_may_throw 0 with 
    | Something_went_wrong -> 0
    in 
      print_endline (string_of_int x);

  (* Pattern matching exceptions *)
  let x = 
    match List.hd [] with 
    | [] -> "empty"
    | _ :: _ -> "nonempty"
    | exception (Failure s) -> s
    in 
      print_endline x;

