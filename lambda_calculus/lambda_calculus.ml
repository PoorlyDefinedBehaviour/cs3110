open Ast
(*
Lambda calculus BNF

e ::= 
    x 
  | e1 e2 
  | fun x -> e 

v ::= fun x -> e

There are only three kinds of expressions in it:
variables, function application, and anonymous functions.
The only values are anonymous functions.
The language isn't even typed.

Big-step evaluation relation for the lambda calculus:

e1 e2 ==> v
  if e1 ==> fun x -> e
  and e2 ==> v2
  and e{v2/x} ==> v

This rule is named call by value, because it requires arguments
to be reduced to a value before a function can be applied.

That's what OCaml uses. Haskell uses a variant called call by name
which is:

e1 e2 ==> v
  if e1 ==> fun x -> e
  and e{e2/x} ==> v

With call by name, e2 does not have to be reduced to a value;
that can lead to greater efficiency if the value of e2 is never needed.

Substitution rule for the lambda calculus:

x{e/x} = e
y{e/x} = y
(e1 e2){e/x} = e1{e/x} e2{e/x}

Substitution in a function:

(fun x -> e'){e/x} = fun x -> e'
(fun y -> e'){e/x} = fun y -> e'{e/x}

That definition turns out to be incorrect. Is violates
the Principle of Name Irrelevance.

Suppose we were attempting this substitution:

(fun z -> x){z/x}

The result would be:

(fun z -> x){z/x}
= fun z -> z

And, suddenly, a function that was not the identity function
becomes the identity function. Whereas, if we had
attempted this substitution:

(fun y -> x){z/x}

The result would be:

(fun y -> x){z/x}
= fun y -> z

Which is not the identity function. So our definition of
substitution inside anonymous functions is incorrect,
because it capturs variables. A variable name being
substituted inside an anonymous function can
accidentally be captured by the function's argument name.

The answer to avoid this problem is called
capture-avoiding substitution.

A correct definition is as follows:

(fun x -> e'){e/x} = fun x -> e'

(fun y -> e'){e/x} = fun y -> e'{e/x} if y is not in FV(e)

where FV(e) means free variables of e, i.e, the variables
that are not bound in it, and is defined as follows:

FV(x) = {x}
FV(e1 e2) = FV(e1) + FV(e2)
FV(fun x -> e) = FV(e) - {x}

and + means set union, and - means set difference.

The definition prevents the substitution (fun z -> x){z/x}
from occurring, because z is in FV(z)
*)
let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

let is_value expression = 
  match expression with 
  | Abs _ -> true 
  | Var _ | App _ -> false

let gensym = 
  let counter = ref 0 in 
  fun () -> 
  incr counter;
  "$x" ^ string_of_int !counter

let rec replace expression new_variable_name old_variable_name = 
  match expression with
  | Var(x) -> if x = old_variable_name then Var(new_variable_name) else expression
  | App(e1, e2) -> App(replace e1 new_variable_name old_variable_name, replace e2 new_variable_name old_variable_name)
  | Abs(x, e') -> 
    let x' = if x = old_variable_name then 
      new_variable_name 
    else 
      old_variable_name
    in
    Abs(x', replace e' new_variable_name old_variable_name)

module VarSet = Set.Make(String)

let rec free_variables expression =
  match expression with 
  | Var(x) -> VarSet.singleton x
  | App(e1, e2) -> VarSet.union (free_variables e1) (free_variables e2)
  | Abs(x, e) -> VarSet.diff (free_variables e) (VarSet.singleton x)

let rec subst expression value x = 
  match expression with 
  | Var(y) -> if x = y then value else expression
  | App(e1, e2) -> App(subst e1 value x, subst e2 value x)
  | Abs(y, e') ->
    if x = y then 
      expression 
    else if not (VarSet.mem y (free_variables value)) then 
      Abs(y, subst e' value x)
    else 
      let new_variable_name = gensym() in
      let new_body = replace e' y new_variable_name in 
      Abs(new_variable_name, subst new_body value x)

let rec eval expression = 
  match expression with
  | Var(x) -> failwith (Format.sprintf "Unbounded variable %s" x)
  | App(e1, e2) -> eval_app e1 e2
  | Abs _ -> expression
and 
eval_app e1 e2 =
  match e1 with
  | Abs(x, e) -> subst e (eval e2) x |> eval
  | _ -> failwith "Tried to app non function"

let _ = 
  (* (fun t -> (fun f -> Var(t))) *)
  "fun t -> fun f -> t" |> parse |> pp_ast |> print_endline;

  (* (fun a -> (fun b -> App(App(Var(a), Var(b)), Var(false)))) *)
  "fun a -> fun b -> a b false" |> parse |> pp_ast |> print_endline;

  (* (fun a -> (fun b -> App(App(Var(a), Var(true)), Var(b)))) *)
  "fun a -> fun b -> a true b" |> parse |> pp_ast |> print_endline;

  (* (fun bool -> App(App(Var(bool), Var(false)), Var(true))) *)
  "fun bool -> bool false true" |> parse |> pp_ast |> print_endline;

  (* (fun y -> Var(y)) *)
  "(fun x -> x) (fun y -> y)" |> parse |> eval |> pp_ast |> print_endline;

  (* (fun t -> (fun f -> Var(t))) *)
  "fun t -> fun f -> t" |> parse |> eval |>pp_ast |> print_endline;

  (* (fun a -> (fun b -> App(App(Var(a), Var(b)), Var(false)))) *)
  "fun a -> fun b -> a b false" |> parse |> eval |> pp_ast |> print_endline;  

  (* (fun a -> (fun b -> App(App(Var(a), Var(true)), Var(b)))) *)
  "fun a -> fun b -> a true b" |> parse |> eval |> pp_ast |> print_endline;

  (* (fun bool -> App(App(Var(bool), Var(false)), Var(true))) *)
  "fun bool -> bool false true" |> parse |> eval |> pp_ast |> print_endline;
