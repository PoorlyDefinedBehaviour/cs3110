(*
Recall the syntax of Core OCaml:

expr :=
    x
  | expr1 expr2
  | fun x -> expr
  | (expr1, expr2)
  | fst expr
  | snd expr
  | Left expr
  | Right expr
  | match expr with
      | Left x1 -> expr1
      | Right x2 -> expr2
  | if expr1 then expr2 else expr3
  | let x = expr1 in expr2

Semantics

<env, x> ==> value
  if env(x) = value

<env, expr1 expr2> ==> value
  if <env, expr1> ==> (| fun x -> expr3, env1 |)
  and <env, expr2> ==> value2
  and <env1[x -> value2], expr3> ==> value

<env, fun x -> expr> ==> (| fun x -> expr, env |)

Evaluation of constants ignores the environment:

<env, integer> ==> integer

<env, bool> ==> bool

Evaluation of most other language features just
uses the environment without changing it:

<env, expr1 + expr2> ==> value3
  if <env, expr1> ==> value1
  and <env, expr2> ==> value2
  and value3 is the result of applying the primitive operation
  + to value1 and value2

<env, (expr1, expr2)> ==> (value1, value2)
  if <env, expr1> ==> value1
  and <env, expr2> ==> value2

<env, fst expr> ==> value1
  if <env, expr> ==> (value1, value2)

<env, snd expr> ==> value2
  if <env, expr> ==> (value1, value2)

<env, Left expr> ==> Left value
  if <env, expr> ==> value

<env, Right expr> ==> Right value
  if <env, expr> ==> value

<env, if expr1 then expr2 else expr3> ==> value2
  if <env, expr1> ==> true
  and <env, expr2> ==> value2

<env, if expr1 then expr2 else expr3> ==> value3
  if <env, expr1> ==> false
  and <env, expr3> ==> value3

Finally, evaluation of binding constructs(i.e., match and let expressions)
extends the environment with a new bindin:

<env, match expr with Left x1 -> expr1 | Right x2 -> expr2> ==> value1
  if <env, expr> ==> Left value
  and <env[x1 -> value], expr1> ==> value1

<env, match expr with Left x1 -> expr1 | Right x2 -> expr2> ==> value2
  if <env, expr> ==> Right value
  and <env[x2 -> value], expr2> ==> value2

<env, let x = expr1 in expr2> ==> value2
  if <env, expr1> ==> value1
  and <env[x -> value1], expr2> ==> value2

Type Checking

A type system is a mathematical description to determine
whether an expression is ill typed or well typed,
and in the latter case, what the type of the expression is.
A type checker is a program that implements a type system, i.e.,
that implements the static semantics of the language.

Commonly, a type system is formulated as ternary relation
HasType(Γ, expr, type), which means that expression expr
has type type in typing context Γ. A typing context, aka
typing environment, is a map from identifiers to types.
The context is used to record what variables are in scope,
and what their types are. The use of the Greek Latter Γ(Gamma)
for contexts is traditional.

The ternary relation HasType is typically written with infix
notation, though, as Γ ⊢ expr : type
*)

let () = print_endline "Hello, World!"
