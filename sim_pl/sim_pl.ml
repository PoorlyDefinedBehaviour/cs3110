open Ast
open Interpreter

let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

let _ = 
  (* let x = Int(3110) in Binary(Add, Var(x), Var(x)) *)
  "let x = 3110 in x + x" |> parse |> pp_ast |> print_endline;

  (* Binary(Add, Int(2), Int(6)) *)
  "2 + 2 * 3" |> parse |> step |> pp_ast |> print_endline;

  (* Int(8) *)
  "2 + 2 * 3" |> parse |> step |> step |> pp_ast |> print_endline;