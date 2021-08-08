open Ast
(*
Lambda calculus syntax:

expr :=
    x
  | expr1 expr2
  | fun x -> expr

value ::=
    fun x -> expr

Dynamic vs Static scope

There are two different ways to understand the scope of a variable:
variables can be dinamically or lexically scoped.

It all comes down to the environment that is used when a function
body is being evaluated:

With the rule of dynamic scope, the body of a function
is evaluated in the current dynamic environment at the time
the function is applied, not the old dynamic environment
that existed at the time the function was defined.

With the rule of lexical scope, the body of a function is
evaluated in the old dynamic environment that existed at
the time the function was defined, not the current environment
when the function is applied.

The consensus after decades of experience with programming
language design is that lexical scope is the right choice.
Perhaps the main reason for that is that lexical scope
supports the Principle of Name Irrelavance. Recall,
that principle says that the name of a varible shouldn't
matter to the meaning of a program, as long as the name is
used consistently.

How do we implement lexical scope?

The answer is that the language implementation must arrange
to keep old environments around.
And  that is indeed what OCaml and other languages must do.
They use a data structure called closure for this purpose.

A closure has two parts:

A code part, which contains a function fun x -> expr.

An environment part, which contains the environment env at the time
that function was defined.

Let's notate a closure as (| fun x -> expr, env |)

Let's define the evaluation relation:

The rule for functions says that an anonymous function
evaluates to a closure:

<env, fun x -> expr> ==> (| fun x -> expr, env |)

That rule sabes the defining environment as part of the closure,
so that it can be used at some future point.

The rule for application says to use that closure:

<env, expr1 expr> ==> value
  if <env, expr1> ==> (| fun x -> expr, env1 |)
  and <env, expr2> ==> value2
  and <env1[x -> value2], expr> ==> value

That rule uses the closure's environment env1 to evaluate the
function body expr .

The rule for let expressions:

<env, let x = expr1 in expr2> ==> value
  if <env, expr1> ==> value1
  and <env[x -> value1], expr2> ==> value
*)
let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

module Environment = Map.Make(String)

type value = 
  | Closure of string * expression * value Environment.t

let rec pp_env env = 
  let bindings = 
    env
    |> Environment.bindings
    |> List.map (fun (key, value) -> key ^ ": " ^ (pp_value value))
  in 
    "{" ^ String.concat ", " bindings ^ "}"
and
pp_value value =
  match value with
  | Closure(x, expr, env) -> Format.sprintf "Closure(%s, %s, %s)" x (pp_ast expr) (pp_env env)

let rec step env expression = 
  match expression with
  | Var(x) -> 
    (match Environment.find_opt x env with
    | None -> failwith (Format.sprintf "Unbounded variable %s" x)
    | Some(value) -> value)
  | Abs(x, expr) -> Closure(x, expr, env)
  | App(expr1, expr2) ->
    match step env expr1 with
    | Closure(x, expr1, closure_env) ->
      let value = step env expr2 in
      let closure_env_with_x_bound = Environment.add x value closure_env in
      Closure(x, expr1, closure_env_with_x_bound)

let rec eval env expression = 
  match expression with 
  | Var(x) -> 
      (match Environment.find_opt x env with
      | None -> failwith (Format.sprintf "Unbounded variable %s" x)
      | Some(value) -> value)
  | Abs(x, expr) -> Closure(x, expr, env)
  | App(expr1, expr2) ->
      match eval env expr1 with
      | Closure(x, expr1, closure_env) ->
        let value = eval env expr2 in
        let closure_env_with_x_bound = Environment.add x value closure_env in
        eval closure_env_with_x_bound expr1
    
let _ =
  (* App((fun x -> Var(x)), (fun y -> Var(y))) *)
  "(fun x -> x) (fun y -> y)" |> parse |> pp_ast |> print_endline;

  (* Closure(y, Var(y), {}) *)
  "(fun x -> x) (fun y -> y)" |> parse |> eval Environment.empty |> pp_value |> print_endline;

  (* Closure(t, (fun f -> Var(t)), {}) *)
  "fun t -> fun f -> t" |> parse |> eval Environment.empty |> pp_value |> print_endline;

  (* Closure(x, Var(x), {x: Closure(y, Var(y), {})}) *)
  "(fun x -> x) (fun y -> y)" |> parse |> step Environment.empty |> pp_value |> print_endline;