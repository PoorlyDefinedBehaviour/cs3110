open Ast

type typ =
  | TVar of string
  | TInt  
  | TBool
  | TAbs of typ * typ

let rec pp_typ typ = 
  match typ with 
  | TVar(x) -> x
  | TInt -> "int"
  | TBool -> "bool"
  | TAbs(argument_typ, body_typ) -> 
      Format.sprintf "(%s -> %s)" (pp_typ argument_typ) (pp_typ body_typ)

module TypingContext = Map.Make(String)

let pp_typing_context context = 
  let bindings = 
    context
    |> TypingContext.bindings
    |> List.map (fun (key, value) -> key ^ ": " ^ (pp_typ value))
  in 
    "{" ^ String.concat ", " bindings ^ "}"

let gen_existential_type_var =
  let alphabet = [|"a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"|] in 
  let generation = ref "'" in
  let i = ref 0 in 
  fun () ->
    let meta_variable = alphabet.(!i) in 
    let type_var = TVar(!generation ^ meta_variable) in 

    if !i = Array.length alphabet then 
      generation := !generation ^ "'";
      i := 0;

    incr i;

    type_var

let rec subst typ type_var new_typ = 
  match typ with 
  | TInt -> TInt 
  | TBool -> TBool
  | TVar(_) as typ' -> if typ' = type_var then new_typ else typ'
  | TAbs(t1, t2) -> TAbs(subst t1 type_var new_typ, subst t2 type_var new_typ)

let subst_existential_type_vars context type_var typ = 
  context 
  |> TypingContext.map (fun typ' -> subst typ' type_var typ)

let rec unify context typ1 typ2 = 
  match (typ1, typ2) with 
  | (TInt, TInt) -> (context, TInt)
  | (TBool, TBool) -> (context, TBool)
  | (TVar(a), TVar(a')) ->
      if a = a' then 
        (context, TVar(a))
      else 
        failwith (Format.sprintf "Type error: tried to unify %s and %s" (pp_typ (TVar(a))) (pp_typ (TVar(a'))))
  | (TAbs(input_typ1, body_typ1), TAbs(input_typ2, body_typ2)) ->
      let (context, t1) = unify context input_typ1 input_typ2 in 
      let (context, t2) = unify context body_typ1 body_typ2 in 
      (context, TAbs(t1, t2))
  | (TAbs(input_typ, body_typ), typ) ->
      let (context, t1) = unify context input_typ typ in 
      let (context, t2) = unify context body_typ typ in 
      (context, TAbs(t1, t2))
  | (TVar(_) as type_var, typ) -> 
      let context = subst_existential_type_vars context type_var typ in
      (context, subst typ type_var typ)
  | _ -> 
    print_endline (pp_typing_context context);
    failwith (Format.sprintf "unify not yet implemented for %s and %s" (pp_typ typ1) (pp_typ typ2))

let rec infer context expr =
  match expr with
  | Int(_) -> (context, TInt)
  | Bool(_) -> (context, TBool)
  | Var(x) -> 
      (match TypingContext.find_opt x context with 
      | None -> failwith (Format.sprintf "Unbounded variable %s" x)
      | Some(typ) -> (context, typ))
  | If(e1, e2, e3) ->
      let (context, t1) = infer context e1 in 
      let (context, t2) = infer context e2 in 
      let (context, t3) = infer context e3 in 

      let (context, _) = unify context t1 TBool in 

      unify context t2 t3
  | Binary(Add, e1, e2) ->
      let (context, typ1) = infer context e1 in
      let (context, _) = unify context typ1 TInt in

      let (context, typ2) = infer context e2 in
      let (context, _) = unify context typ2 TInt in
    
      (context, TInt)
  | Binary(And, e1, e2) ->
      print_endline ("binary " ^ string_of_expr e1 ^ " and " ^ string_of_expr e2);
      let (context, t1) = infer context e1 in 
      print_endline (pp_typ t1);
      print_endline (pp_typing_context context);
      let (context, _) = unify context t1 TBool in 

      let (context, t2) = infer context e2 in 
      let (context, _) = unify context t2 TBool in 

      (context, TBool)
  | App(e1, e2) ->
      let (context, function_type) = infer context e1 in 
      let (context, argument_type) = infer context e2 in 

      (match function_type with 
      | TAbs(parameter_type, body_type) -> 
          let (context, _) = unify context parameter_type argument_type in 
          (context, body_type)
      | TVar(_) as type_var ->
          let new_type_var = gen_existential_type_var() in
          let function_type = TAbs(argument_type, new_type_var) in 
          let context = subst_existential_type_vars context type_var function_type in 
          print_endline (pp_typing_context context);
          (context, new_type_var)
      | _ -> failwith (Format.sprintf "Type error: tried to apply %s : %s to %s : %s" (pp_expr e1) (pp_typ function_type) (pp_expr e2) (pp_typ argument_type)))
  | Abs(x, e1) ->
      let type_var = gen_existential_type_var() in 
      let context = TypingContext.add x type_var context in 
      let (context, t2) = infer context e1 in 
      let t1 = TypingContext.find x context in 
      (context, TAbs(t1, t2))
  | Let(x, e1, e2) ->
      let (context, t1) = infer context e1 in 
      let context = TypingContext.add x t1 context in 
      infer context e2

let typecheck expr =
  print_endline (string_of_expr expr);
  let (context, typ) = infer TypingContext.empty expr in 
  print_endline (Format.sprintf "%s ⊢ %s : %s" (pp_typing_context context) (pp_expr expr) (pp_typ typ));
  ()
  