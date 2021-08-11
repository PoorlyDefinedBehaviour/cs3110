open Ast

type typ =
  | TVar of string
  | TInt  
  | TBool
  | TAbs of typ * typ

let rec pp_typ typ = 
  match typ with 
  | TVar(x) -> Format.sprintf "TVar(%s)" x
  | TInt -> "TInt"
  | TBool -> "TBool"
  | TAbs(argument_typ, body_typ) -> 
      Format.sprintf ("TAbs(%s, %s)") (pp_typ argument_typ) (pp_typ body_typ)

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

let rec subst substitutions typ =
  match typ with 
  | TInt -> TInt
  | TBool -> TBool
  | TVar(x) -> 
      (match SubstitutionMap.find_opt x substitutions with
      | None -> TVar(x)
      | Some(typ) -> typ)
  | TAbs(input_typ, output_typ) ->
      TAbs(subst substitutions input_typ, subst substitutions output_typ)

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

type scheme = 
  | Scheme of string list * typ

let debug_expr expr =
  print_endline ("expression: " ^ pp_ast expr);
  ()

let debug_expr_typ expr typ =
  print_endline (pp_ast expr ^ " has type " ^ pp_typ typ); 
  ()

let debug_subst_typ substitutions = 
  print_endline ("substitutions: " ^ pp_substitutions substitutions);
  ()

let rec infer context expr =
  debug_expr expr;

  match expr with
  | Int(_) -> (SubstitutionMap.empty, TInt)
  | Bool(_) -> (SubstitutionMap.empty, TBool)  
  | Var(x) -> 
      (match TypingContext.find_opt x context with 
      | None -> failwith (Format.sprintf "Unbounded variable %s" x)
      | Some(Scheme(_, typ)) -> (SubstitutionMap.empty, typ))
  | Binary(Add, e1, e2) ->
      let (s1, typ1) = infer context e1 in
      debug_expr_typ e1 typ1;
      let (s2, typ2) = infer context e2 in
      debug_expr_typ e2 typ2;

      let (s3, typ) = 
        match (typ1, typ2) with 
        | (TVar(x1), TVar(x2)) -> (SubstitutionMap.empty |> SubstitutionMap.add x1 TInt |> SubstitutionMap.add x2 TInt, TInt)
        | (TVar(x1), typ) -> (SubstitutionMap.empty |> SubstitutionMap.add x1 TInt, typ)
        | (typ, TVar(x2)) -> (SubstitutionMap.empty |> SubstitutionMap.add x2 TInt, typ)
        | (TInt, TInt) -> (SubstitutionMap.empty, TInt)
        | (typ1, typ2) ->
            if typ1 <> typ2 then 
              failwith (Format.sprintf "Type error: expected int + int, got %s + %s" (pp_typ typ1) (pp_typ typ2))
            else
            (SubstitutionMap.empty, typ1)
      in
        debug_subst_typ (merge_subst_map (merge_subst_map s1 s2) s3);
        (merge_subst_map (merge_subst_map s1 s2) s3, typ)
  | App(e1, e2) ->
      debug_expr e1;
      debug_expr e2;
      let (s1, typ1) = infer context e1 in 
      let (s2, typ2) = infer context e2 in

      let s3 = merge_subst_map s1 s2 in 

      (match (typ1, typ2) with
      | (TVar(a), typ2) -> 
          let s3 = 
            s3 
            |> SubstitutionMap.remove a
            |> SubstitutionMap.add a (TAbs(typ2, gen_type_var()))
          in 
            (s3, gen_type_var())
      | (TAbs(input_typ, body_typ), typ2) when input_typ = typ2 -> (s3, body_typ)
      | (typ1, typ2) -> failwith (Format.sprintf "Type error: got %s applied to %s" (pp_typ typ1) (pp_typ typ2)))
  | Abs(x, e1) ->
      let type_var = gen_type_var() in
      let context' = TypingContext.remove x context in 
      print_endline ("setting " ^ x ^ " type to " ^ (pp_typ type_var));
      let context'' = TypingContext.add x (Scheme([], type_var)) context' in
      let (substitutions, typ) = infer context'' e1 in 
      debug_expr_typ e1 typ;
      debug_subst_typ substitutions;
      (substitutions, TAbs(subst substitutions type_var, typ))
  | _ -> failwith (Format.sprintf "not yet implemented for %s" (pp_ast expr))

let typecheck expr =
  let (s, typ) = infer TypingContext.empty expr in 
  let typ = subst s typ in 
  debug_expr_typ expr typ;
  ()
  