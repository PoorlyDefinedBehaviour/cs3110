{
  open Parser
}

let whitespace = [' ' '\t']
let letter = ['a'-'z' 'A'-'Z']
let identifier = letter+

rule read = 
  parse 
  | whitespace { read lexbuf }
  | "(" { LEFTPAREN }
  | ")" { RIGHTPAREN }
  | "->" { ARROW }
  | "fun" { FUN }
  | identifier { VAR(Lexing.lexeme lexbuf)}
  | eof { EOF }