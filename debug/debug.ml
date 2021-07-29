(*
Function traces
Suppose you want to see the trace of recursive
calls and returns for a function.
Use the #trace directive.
*)
let rec fib x = if x<=1 then 1 else fib(x-1) + fib(x-2)
#trace fib

(*
OCaml has a debugging tool called ocamldebug.
*)

let _ = 
  print_endline (fib 5);