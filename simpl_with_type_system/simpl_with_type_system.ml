(*
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

Recall the syntax of SimPL:

expr :=
    x
  | integer
  | bool 
  | expr1 binop expr2
  | if expr1 then expr2 else expr3
  | let x = expr1 in expr2

binop ::=
    +
  | *
  | <=

Let's define a type system Γ ⊢ expr : type for SimPL.
The only types in SimPL are integers and booleans.

type ::=
    integer
  | bool

Base Cases

An integer constant has type int in any context whatsoever,
a Boolean constant likewise always has type bool, and
a variable has whatever type the context says it should have.
Here are the typing rules that express those ideas:

Γ ⊢ integer : int -- integer always have type int
Γ ⊢ boolean : bool -- booleans always have type bool
{x: type1, ...} ⊢ x : type1 -- a variable has whatever type the
context says it has.

Inductive Cases

Let expressions

Γ ⊢ let x = expr1 in expr2 : type2
  if Γ ⊢ expr1 : type1
  and Γ[x -> type1] ⊢ expr2 : type2

The rule says that let x = expr1 in expr2 has type type2
in context Γ, but only if certain conditions hold.
The first condition is that expr1 has type type1 in context Γ.
The second is that expr2 has type type2 in a new context,
which is Γ extended to bind x to type1

Binary operators

Γ ⊢ expr1 binop expr1 : int
  if binop is +
  and Γ ⊢ expr1 : int
  and Γ ⊢ expr2 : int

Γ ⊢ expr1 binop expr2 : int
  if binop is *
  and Γ ⊢ expr1 : int
  and Γ ⊢ expr2 : int

Γ ⊢ expr1 binop expr2 : bool
  if binop is <=
  and Γ ⊢ expr1 : int
  and Γ ⊢ expr2 : int

If expressions

Γ ⊢ if expr1 then expr2 else expr3 : type1
  if Γ ⊢ expr1 : bool
  and Γ ⊢ expr2 : type1
  and Γ ⊢ expr3 : type1
*)
open Ast

type typ = 
  | TInt 
  | TBool

let pp_typ typ = 
  match typ with 
  | TInt -> "TInt"
  | TBool -> "TBool"

module TypingContext = struct 
  type t = (string * typ) list 

  let empty = []

  let lookup = List.assoc_opt

  let extend context identifier typ = (identifier, typ) :: context  
end

let rec typeof context expr = 
  match expr with 
  | Int(_) -> TInt
  | Bool(_) -> TBool 
  | Var(x) -> 
      (match TypingContext.lookup x context with 
      | None -> failwith (Format.sprintf "Unbounded variable %s" x)
      | Some(typ) -> typ)
  | Let(x, expr1, expr2) -> 
      let type1 = typeof context expr1 in
      let context' = TypingContext.extend context x type1 in
      typeof context' expr2
  | Binary(operator, expr1, expr2) -> 
      let type1 = typeof context expr1 in
      let type2 = typeof context expr2 in

      (match(operator, type1, type2) with 
      | (Add, TInt, TInt) -> TInt 
      | (Multiply, TInt, TInt) -> TInt
      | (LessThanOrEqual, TInt, TInt) -> TBool
      | _ -> failwith (Format.sprintf "Operator and operand type mismatch: operation %s with %s and %s" (pp_binary_operator operator) (pp_typ type1) (pp_typ type2)))
  | If(expr1, expr2, expr3) -> 
      let type1 = typeof context expr1 in
      let type2 = typeof context expr2 in 
      let type3 = typeof context expr3 in 
    
      if type1 <> TBool then 
        failwith (Format.sprintf "If condition must have type bool, got %s" (pp_typ type1))
      else if type2 <> type3 then 
        failwith (Format.sprintf "If branches must have the same type, got if %s then %s else %s" (pp_typ type1) (pp_typ type2) (pp_typ type3))
      else 
        type3 

let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

let _ = 
  (* TInt *)
  "1" |> parse |> typeof TypingContext.empty |> pp_typ |> print_endline; 

  (* TBool *)
  "true" |> parse |> typeof TypingContext.empty |> pp_typ |> print_endline; 

  (* TInt *)
  "let x = 1 in x" |> parse |> typeof TypingContext.empty |> pp_typ |> print_endline; 

  (* TInt *)
  "let x = 1 in x + x" |> parse |> typeof TypingContext.empty |> pp_typ |> print_endline; 

  (* TInt *)
  "let x = 1 in if x <= 5 then x + 1 else x * 2" |> parse |> typeof TypingContext.empty |> pp_typ |> print_endline; 
