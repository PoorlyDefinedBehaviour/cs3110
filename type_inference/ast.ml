type operator = 
  | Add 
  | And

let pp_operator operator = 
  match operator with
  | Add -> "+"
  | And -> "and"

type expression =
  | Var of string (* x *)
  | Int of int (* 1 *)
  | Bool of bool (* true false *)
  | App of expression * expression (* e1 e2 *)
  | Abs of string * expression (* fun x -> e1 *)
  | Let of string * expression * expression (* let x = expr1 in expr 2 *)
  | Binary of operator * expression * expression (* 2 + 2 *)
  | If of expression * expression * expression (* if e1 then e2 else e3 *)

let rec pp_expr expr =
  match expr with 
  | Var(identifier) -> identifier
  | Int(i) -> string_of_int i
  | Bool(b) -> string_of_bool b
  | App(f, e1) -> 
      Format.sprintf "%s %s" (pp_expr f) (pp_expr e1)
  | Abs(x, body) ->
      Format.sprintf {|(\%s -> %s)|} x (pp_expr body)
  | Let(identifier, value, body) ->
      Format.sprintf "let %s = %s in %s" identifier (pp_expr value) (pp_expr body)
  | Binary(operator, left, right) -> 
      Format.sprintf "(%s %s %s)" (pp_expr left) (pp_operator operator) (pp_expr right)
  | If(e1, e2, e3) ->
      Format.sprintf "if %s then %s else %s" (pp_expr e1) (pp_expr e2) (pp_expr e3)
    
let rec string_of_expr expr =
  match expr with 
  | Var(identifier) -> Format.sprintf "Var(%s)" identifier
  | Int(i) -> Format.sprintf "Int(%d)" i
  | Bool(b) -> Format.sprintf "Bool(%b)" b
  | App(f, e1) -> 
      Format.sprintf "App(%s, %s)" (string_of_expr f) (string_of_expr e1)
  | Abs(x, body) ->
      Format.sprintf "Abs(%s, %s)" x (string_of_expr body)
  | Let(identifier, value, body) ->
      Format.sprintf "Let(%s, %s, %s)" identifier (string_of_expr value) (string_of_expr body)
  | Binary(operator, left, right) -> 
      Format.sprintf "Binary(%s, %s, %s)" (pp_operator operator) (string_of_expr left) (string_of_expr right)
  | If(e1, e2, e3) ->
      Format.sprintf "If(%s, %s, %s)" (string_of_expr e1) (string_of_expr e2) (string_of_expr e3)
    
