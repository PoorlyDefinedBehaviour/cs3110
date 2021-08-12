type operator = 
  | Add 

let pp_operator operator = 
  match operator with
  | Add -> "+"

type expression =
  | Var of string (* x *)
  | Int of int (* 1 *)
  | Bool of bool (* true false *)
  | App of expression * expression (* e1 e2 *)
  | Abs of string * expression (* fun x -> e1 *)
  | Let of string * expression * expression (* let x = expr1 in expr 2 *)
  | Binary of operator * expression * expression

  let rec pp_expr expr =
    match expr with 
    | Var(identifier) -> identifier
    | Int(i) -> string_of_int i
    | Bool(b) -> string_of_bool b
    | App(f, e1) -> 
        Format.sprintf "%s %s" (pp_expr f) (pp_expr e1)
    | Abs(x, body) ->
        Format.sprintf "(fun %s -> %s)" x (pp_expr body)
    | Let(identifier, value, body) ->
        Format.sprintf "let %s = %s in %s" identifier (pp_expr value) (pp_expr body)
    | Binary(operator, left, right) -> 
        Format.sprintf "(%s %s %s)" (pp_expr left) (pp_operator operator) (pp_expr right)
    