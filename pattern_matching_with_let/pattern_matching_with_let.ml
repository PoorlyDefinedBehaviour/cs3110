(*
The left-hand side of a let expression 
may be a pattern, not just an identifier.

let p = e1 in e2

NOTE: 
Is this just like elixir?

Dynamic semantics

To evaluate let p = e1 in e2

Evaluate e1 to v1

Match v1 against pattern p. If it doesn't match,
raise the exception Match_failure. Otherwise,
if it does match, it produces a set b of bindings.

Substitute those bindings b in e2, yield a new 
expressio e2'.

Evaluate e2' to a value v2.

The result of evaluating the let expression is v2.

Static semantics

If e1: t1
the pattern variables in p are x1..xn
e2: t2 under the assumption that for all i in 1..n
it holds that xi: ti,
then (let p = e1 in e2) : t2

Let definitions

Let definitions can be understood as let expression
whose body has not yet been given. So their
syntax can be generalized to
let p = e
*)

let _ =
