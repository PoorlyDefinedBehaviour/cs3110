%{
open Ast
%}

%token <string> VAR
%token <int> INT
%token APP
%token LEFTPAREN
%token RIGHTPAREN
%token TRUE
%token FALSE
%token ARROW
%token LAMBDA
%token PLUS
%token LET
%token IN
%token EQUAL
%token IF 
%token THEN
%token ELSE
%token AND
%token EOF

%start <Ast.expression> program

/* tokens that start an expression */
%nonassoc VAR LEFTPAREN LAMBDA AND
%left APP

%%

program:
  | e = expression; EOF { e }

expression:
  | x = VAR { Var(x) }
  | TRUE { Bool(true) }
  | FALSE { Bool(false) }
  | i = INT { Int(i)}
  | e1 = expression; PLUS; e2 = expression { Binary(Add, e1, e2) }
  | e1 = expression; AND; e2 = expression { Binary(And, e1, e2) }
  | e1 = expression; e2 = expression %prec APP { App(e1, e2) }
  | LAMBDA; x = VAR; ARROW; e = expression { Abs(x, e) }
  | LET; x = VAR; EQUAL; e1 = expression; IN; e2 = expression { Let(x, e1, e2) }
  | IF; e1 = expression; THEN; e2 = expression; ELSE; e3 = expression { If(e1, e2, e3) }
  | LEFTPAREN; e = expression; RIGHTPAREN { e }

