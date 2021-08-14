(*
[START] Example 1

Consider these functions:
*)
let twice f x = f (f x)

let compose f g x = f (g x)
(*
We have that twice h = h (h x), beucase both sides would
evaluate to the same value.
Indeed, twice h x -->* h (h x) in the substitution model,
and from there some value would be produced (given definitions
for h and x). Likewise, compose h h x = h (h x). 
Thus we have:

twice h x = h (h x) = compose h h x

Therefore can conclude that twice h x = compose h h x. 
And by extensionality we can simplify that equality.
Since twice h x = compose h h x holds for all x, we can conclude
twice h = compose h h.

[END] Example 1
*)

(*
[START] Example 2

Let's define an infix operator for function composition:
*)
let ( << ) f g x = f (g x)
(*
Then we can prove that composition is associative, using
equational reasoning:

Theorem: (f << g) << h = f << (g << h)

Proof: by extensionality, we need to show
  ((f << g) << h) x = (f << (g << h))) x
for an arbitrary x.

  ((f << g) << h) x
= (f << g) (h x)
= f (g (h x))

and

  (f << (g << h)) x
= (f << g) (h x)
= f (g (h x))
*)

let () = print_endline "Hello, World!"
