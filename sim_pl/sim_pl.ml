open Ast
open Interpreter

let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

let _ = 
  (* let x = Int(3110) in Binary(Add, Var(x), Var(x)) *)
  "let x = 3110 in x + x" |> parse |> pp_ast |> print_endline;

  (* Binary(Add, Int(3110), Int(3110)) *)
  "let x = 3110 in x + x" |> parse |> small_step |> pp_ast |> print_endline;

  let expr = "2 + 2 * 3" in 
  (* Binary(Add, Int(2), Binary(Multiply, Int(2), Int(3))) *)
  expr |> parse |> pp_ast |> print_endline;

  (* Binary(Add, Int(2), Int(6)) *)
  expr |> parse |> small_step |> pp_ast |> print_endline;

  (* Int(8) *)
  expr |> parse |> small_step |> small_step |> pp_ast |> print_endline;

  (* Int(8) *)
  expr |> parse |> big_step |> pp_ast |> print_endline;