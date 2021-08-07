%{
open Ast
%}

%token <string> VAR
%token APP
%token LEFTPAREN
%token RIGHTPAREN
%token ARROW
%token FUN
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
  | e1 = expression; e2 = expression %prec APP { App(e1, e2) }
  | FUN; x = VAR; ARROW; e = expression { Abs(x, e)}
  | LEFTPAREN; e = expression; RIGHTPAREN { e }