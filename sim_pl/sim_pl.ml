open Ast

let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

let _ = 
  (* let x = Int(3110) in Binary(Add, Var(x), Var(x)) *)
  "let x = 3110 in x + x" |> parse |> pp_ast |> print_endline;