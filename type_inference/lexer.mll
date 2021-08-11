{
  open Parser
}

let whitespace = [' ' '\t']
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
  | "fun" { FUN }
  | "+" { PLUS }
  | identifier { VAR(Lexing.lexeme lexbuf)}
  | int { INT(int_of_string (Lexing.lexeme lexbuf)) }
  | eof { EOF }