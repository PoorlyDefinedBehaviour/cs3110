(*
Backus-Naur Form

The standard way to describe the syntax of a languae is with
a mathematical notation called Backus-Naur Form, 
named for its inventors, John Backus and Peter Naur.
There are many variants of BNF.

BNF uses a set of derivation rules to describe the syntax of
a language.

Here's the BNF description of a tiny language of expressions
that include just the integers and addition:

e ::= i | e + e
i ::= <integers>

There rules say that an expression e is either an integer i,
or two expressions with the symbol + appearing between them.
The syntax of integers is left unspecified by these rules.

Each rule has the form

metavariable ::= symbols | ... | symbols

A metavariable is a variable used in the BNF rules, rather than
a variable in the language being described.The ::= and | that
appear in the rules are metasyntax: BNF syntax used to describe
the language's syntax. Symbols are sequences that can include
metavariables(such as i and e) as well as tokens of the language
(such as +). Whitespace is not relevant in these rules.

Sometimes we might want to easily refer to individual occurrences
of metavariables. We do that by appending some distinguishing mark
to the metavariables. For example, we could rewruite the first rule above
as

e ::= i | e1 + e2

or as

e ::= i | e + e'
*)

let _ = print_endline "Hello, World!"
