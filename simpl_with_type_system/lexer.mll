{
open Parser
}

let whitespace = [' ' '\t']+
let digit = ['0'-'9']
let int = '-'? digit+
let letter = ['a'-'z' 'A'-'Z']
let identifier = letter+

rule read = 
  parse 
  | whitespace { read lexbuf }
  | "true" { TRUE }
  | "false" { FALSE }
  | "<=" { LESSTHANOREQUAL }
  | "*" { TIMES }
  | "+" { PLUS }
  | "(" { LEFTPAREN }
  | ")" { RIGHTPAREN }
  | "let" { LET }
  | "=" { EQUALS }
  | "in" { IN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | identifier { IDENTIFIER(Lexing.lexeme lexbuf) }
  | int { INT(int_of_string (Lexing.lexeme lexbuf))}
  | eof { EOF}