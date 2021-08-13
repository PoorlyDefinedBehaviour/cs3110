{
  open Parser
}

let whitespace = [' ' '\t' '\n']
let letter = ['a'-'z' 'A'-'Z']
let digit = ['0'-'9']
let int = '-'? digit+
let identifier = letter+

rule read = 
  parse 
  | whitespace { read lexbuf }
  | "true" { TRUE }
  | "false" { FALSE }
  | "(" { LEFTPAREN }
  | ")" { RIGHTPAREN }
  | "->" { ARROW }
  | "\\" { LAMBDA }
  | "+" { PLUS }
  | "let" { LET }
  | "=" { EQUAL }
  | "in" { IN }
  | "if" { IF }
  | "then" { THEN }
  | "else" { ELSE }
  | "and" { AND }
  | identifier { VAR(Lexing.lexeme lexbuf)}
  | int { INT(int_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }