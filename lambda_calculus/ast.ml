type expression =
  | Var of string (* x *)
  | App of expression * expression (* e1 e2 *)
  | Abs of string * expression (* fun x -> e1 *)

let rec pp_ast ast =
  match ast with
  | Var(x) -> Format.sprintf "Var(%s)" x
  | App(e1, e2) -> Format.sprintf "App(%s, %s)" (pp_ast e1) (pp_ast e2)
  | Abs(x, e) -> Format.sprintf "(fun %s -> %s)" x (pp_ast e)