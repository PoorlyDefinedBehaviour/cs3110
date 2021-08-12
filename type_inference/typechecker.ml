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
      Format.sprintf ("%s -> %s") (pp_typ argument_typ) (pp_typ body_typ)

module TypeVariablesSet = Set.Make(String)

let rec free_type_variables typ = 
  match typ with 
  | TVar(x) -> TypeVariablesSet.singleton x
  | TInt -> TypeVariablesSet.empty
  | TBool -> TypeVariablesSet.empty
  | TAbs(argument_typ, body_typ) ->
      TypeVariablesSet.union (free_type_variables argument_typ) (free_type_variables body_typ)

module SubstitutionMap = Map.Make(String)

let merge_subst_map m1 m2 = 
  SubstitutionMap.merge 
      (fun _ x0 y0 -> 
         match x0, y0 with 
         | None, None -> None
         | None, Some v | Some v, None -> Some v
         | Some _, Some v -> Some v)
      m1 m2

let pp_substitutions substitutions = 
  let bindings = 
    substitutions
    |> SubstitutionMap.bindings
    |> List.map (fun (key, value) -> key ^ ": " ^ (pp_typ value))
  in 
    "{" ^ String.concat ", " bindings ^ "}"

module TypingContext = Map.Make(String)


let pp_typing_context context = 
  let bindings = 
    context
    |> TypingContext.bindings
    |> List.map (fun (key, value) -> key ^ ": " ^ (pp_typ value))
  in 
    "{" ^ String.concat ", " bindings ^ "}"

let debug_typing_context context = 
  print_endline ("typing context: " ^ pp_typing_context context);
  ()

let gen_type_var =
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

let debug_expr_typ expr typ =
  print_endline (pp_expr expr ^ " has type " ^ pp_typ typ); 
  ()

let debug_subst_typ substitutions = 
  print_endline ("substitutions: " ^ pp_substitutions substitutions);
  ()

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
  | (TVar(a), typ) -> (TypingContext.add a typ context, typ)
  | (typ, TVar(a)) -> (TypingContext.add a typ context, typ)
  | _ -> failwith (Format.sprintf "not yet implemented for %s and %s" (pp_typ typ1) (pp_typ typ2))

let rec infer context expr =
  match expr with
  | Int(_) -> (context, TInt)
  | Bool(_) -> (context, TBool)
  | Var(x) -> 
      (match TypingContext.find_opt x context with 
      | None -> failwith (Format.sprintf "Unbounded variable %s" x)
      | Some(typ) -> (context, typ))
  | Binary(Add, e1, e2) ->
      let (context, typ1) = infer context e1 in
      let (context, typ2) = infer context e2 in
      print_endline "-------";
      
      
      let (context, _) = unify context typ1 TInt in
      debug_typing_context context;
      let (context, typ) = unify context typ2 TInt in
      print_endline "-------";
      (context, typ)
  | App(e1, e2) ->
      print_endline "--- infer app ---";

      let (context, typ1) = infer context e1 in 

      let (context, typ2) = infer context e2 in

      let (context, typ3) = unify context typ2 (gen_type_var()) in 
    
      let (context, _) = unify context typ1 (TAbs(typ2, typ3)) in 

      print_endline "--- infer app ---";
      (context, typ3)

  | Abs(x, e1) ->
      print_endline "--- infer abs ---";
      let type_var = gen_type_var() in
      print_endline ("setting " ^ x ^ " type to " ^ (pp_typ type_var));
      let context = TypingContext.add x type_var context in
      let (context, body_typ) = infer context e1 in 
      debug_typing_context context;
      debug_expr_typ e1 body_typ;
      
      let input_typ = 
        match type_var with 
        | TVar(a) -> 
            (match TypingContext.find_opt a context with 
            | None -> type_var 
            | Some(typ) -> typ)
        | _ -> failwith "unreachable"
      in
        debug_expr_typ e1 input_typ;
        debug_typing_context context;
        let context = TypingContext.add x input_typ context in 
        debug_typing_context context;
        print_endline "--- infer abs ---";
        (context, TAbs(input_typ, body_typ))
  | _ -> failwith (Format.sprintf "not yet implemented for %s" (pp_expr expr))

let typecheck expr =
  let (context, typ) = infer TypingContext.empty expr in 
  debug_typing_context context;
  debug_expr_typ expr typ;
  ()
  