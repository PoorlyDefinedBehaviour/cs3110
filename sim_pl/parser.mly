%{
open Ast
%}

%token <int> INT 
%token <string> IDENTIFIER
%token TRUE
%token FALSE
%token LESSTHANOREQUAL
%token TIMES
%token PLUS
%token LEFTPAREN
%token RIGHTPAREN
%token LET
%token EQUALS
%token IN
%token IF 
%token THEN
%token ELSE 
%token EOF

%nonassoc IN
%nonassoc ELSE 
%left LESSTHANOREQUAL
%left PLUS 
%left TIMES

%start <Ast.expression> program

%%

program:
  | e = expression; EOF { e }

expression:
  | i = INT { Int i }
  | x = IDENTIFIER { Var x }
  | TRUE { Bool true }
  | FALSE { Bool false }
  | e1 = expression; LESSTHANOREQUAL; e2 = expression { Binary(LessThanOrEqual, e1, e2) }
  | e1 = expression; TIMES; e2 = expression { Binary(Multiply, e1, e2) }
  | e1 = expression; PLUS; e2 = expression { Binary(Add, e1, e2) }
  | LET; x = IDENTIFIER; EQUALS; e1 = expression; IN ; e2 = expression { Let(x, e1, e2) }
  | IF; e1 = expression; THEN; e2 = expression; ELSE; e3 = expression { If(e1, e2, e3) }
  | LEFTPAREN; e = expression; RIGHTPAREN { e }