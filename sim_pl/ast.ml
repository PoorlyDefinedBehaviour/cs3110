
(*
As a running example for the next few sections,
we'll use a very simple programming language that we call
SimPL. Here is its syntax in BNF:

expression ::= 
  identifier 
  | integer 
  | bool 
  | expression1 binary_operator expression2
  | let x = expression1 in expression2
  | if expression1 then expression2 else expression3

binary_operator := + | * | <=

identifier := <identifier>

integer := <integer>

bool ::= true | false
*)

(* binary_operator *)
type binary_operator = 
  | Add (* + *)
  | Multiply  (* * *)
  | LessThanOrEqual (* <= *)

let pp_binary_operator operator = 
  match operator with 
  | Add -> "Add"
  | Multiply -> "Multiply"
  | LessThanOrEqual -> "LessThanOrEqual"

type expression = 
  | Var of string (* identifier *)
  | Int of int (* integer *)
  | Bool of bool (* bool *)
  | Binary of binary_operator * expression * expression (* binary_operator *)
  | Let of string * expression * expression (* let x = expression1 in expression2 *)
  | If of expression * expression * expression (* if expression1 then expression2 else expression3 *)

let rec pp_ast ast = 
  match ast with 
  | Var(identifier) -> Format.sprintf "Var(%s)" identifier 
  | Int(i) -> Format.sprintf "Int(%d)" i
  | Bool(b) -> Format.sprintf "Bool(%b)" b 
  | Binary(operator, left, right) -> 
      Format.sprintf "Binary(%s, %s, %s)" (pp_binary_operator operator) (pp_ast left) (pp_ast right)
  | Let(identifier, value, body) ->
      Format.sprintf "let %s = %s in %s" identifier (pp_ast value) (pp_ast body)
  | If(condition, consequence, alternative) ->
      Format.sprintf "If %s then %s else %s" (pp_ast condition) (pp_ast consequence) (pp_ast alternative)