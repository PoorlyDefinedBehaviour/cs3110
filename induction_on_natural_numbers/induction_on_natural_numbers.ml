(*
The following function sums the non-negative 
integers up to n:
*)
let rec sumto n =
  if n = 0 then 
    0
  else 
    n + sumto (n - 1)
(*
The same summation can be expressed in closed form as:
n * (n + 1) / 2.

To prove that forall n >= 0, sum to n = n * (n + 1) /2,
we will need mathematical induction.

Induction on the natural numbers is formulated as follows:

forall properties P,
  if P(0),
  and if forall k, P(k) implies P(k + 1),
  then forall n, P(n)

This is called the induction principle for natural numbers.
The base case is to prove P(0), and the inductive case
is to prove that P(k + 1) holds under the assumption
of the inductive hypothesis P(k).

Let's use induction to prove the correctness of sumto:

Claim: sumto n = n * (n + 1) / 2

Proof: by induction on n.
P(n) = sumto n = n * (n + 1) / 2

Base case: n = 0
Show: sumto 0 = 0 * (n + 1) / 2

  sumto 0 
= { evaluation }
  0
= { algebra }
  0 * (n + 1) / 2

Inductive case: n = k + 1
Show: sumto (k + 1)   = (k + 1) * ((k + 1) + 1) / 2
IH: sumto k = k * (k + 1) / 2

  sumto (k + 1)
= { evaluation }
  k + 1 + sumto k
= { IH }
  k + 1 + k * (k + 1) / 2
= { algebra }
  (k + 1) * (k + 2) / 2
*)

let () = print_endline "Hello, World!"
