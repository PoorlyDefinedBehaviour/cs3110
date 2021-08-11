type operator = 
  | Add 

let pp_operator operator = 
  match operator with
  | Add -> "Add"

type expression =
  | Var of string (* x *)
  | Int of int (* 1 *)
  | Bool of bool (* true false *)
  | App of expression * expression (* e1 e2 *)
  | Abs of string * expression (* fun x -> e1 *)
  | Let of string * expression * expression (* let x = expr1 in expr 2 *)
  | Binary of operator * expression * expression

let rec pp_ast ast =
  match ast with
  | Var(x) -> Format.sprintf "Var(%s)" x
  | Int(i) -> Format.sprintf "Int(%d)" i
  | Bool(b) -> Format.sprintf "Bool(%s)" (if b then "true" else "false")
  | App(e1, e2) -> Format.sprintf "App(%s, %s)" (pp_ast e1) (pp_ast e2)
  | Abs(x, e) -> Format.sprintf "(fun %s -> %s)" x (pp_ast e)
  | Let(x, e1, e2) -> Format.sprintf "let %s = %s in %s" x (pp_ast e1) (pp_ast e2)
  | Binary(operator, e1, e2) -> Format.sprintf "Binary(%s, %s, %s)" (pp_operator operator) (pp_ast e1) (pp_ast e2)


  