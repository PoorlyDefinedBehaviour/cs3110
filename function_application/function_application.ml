
(*
Syntax
e0 e1 e2 en

The first expression e0 is the function, and it is applied
to arguments e1 through en. Parentheses are not required
around the arguments to indicate function application, 
as they are in other languages.

Static semantics
if e0: t1 -> ... -> tn -> u and e1:t1 and
en:tn then e0 e1 ... en : u

Dynamic semantics
To evaluate e0 e1 ... en:

Evaluate e0 to a function. Also evaluate the argument
expressions e1 through en to valutes v1 through vn

For e0, the resut might be an anonymous function
fun x1 ... xn -> e or a name f. In the latter case,
we need to find the definition of f, which we
can assume to be of the form let rec f x1 ... xn = e.
Either way, we now know the argument names x1 through xn and the body e.

Substitute each value vi for the corresponding argument name xi
in the body e of the function.
That substitution results in a new expression e'.

Evaluate e' to a value v, which is the result of evaluating e0 e1 ... en
*)
let _ = 
  (*
  If you compare these evaluation rules to the rules for
  let expressions, you will notice they both involve substitution.
  This is not an accident. In fact, anywhere let x = e1 in e2
  appears in program, we could replace it with (fun x -> e2) e1.
  They are sintactically different but semantically equivalent. 
  In essence, let expressions are just syntactic sugar for anonymous
  function application.
  *)
  let x = 1 in
  print_endline (string_of_int x);

  (fun x -> print_endline (string_of_int x)) 1;


