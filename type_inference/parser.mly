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
%token FUN
%token PLUS
%token EOF

%start <Ast.expression> program

/* tokens that start an expression */
%nonassoc VAR LEFTPAREN FUN 
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
  | e1 = expression; e2 = expression %prec APP { App(e1, e2) }
  | FUN; x = VAR; ARROW; e = expression { Abs(x, e) }
  | LEFTPAREN; e = expression; RIGHTPAREN { e }