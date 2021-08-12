(*
Java and OCaml are statically typed languages, meaning every
binding has a type that is determined at compile time,
that is, before any part of the program is executed.
The type-checker is a compile-time procedure that either
accepts or rejects a program. By contrast, JavaScript and
ruby are dynamically-typed languages; the type of a binding
is not determined ahead of time.
Computations like binding 42 to x and then treating x
as a string therefore either result in run-time errors,
or run-time conversion between types.

Unlike Java, OCaml is implicitly typed, meaning programmers
rarely need to write down the types of bindings.
This is often convenient, especially with higher-order functions.
But implicit typing in no way changes the fact that OCaml
is statically typed. Rather, the type-checker has to be more
sophisticated because it must infer what the type annotations
would have been had the programmers written all of them.
In principle, type inference and type checking could be
separate produces(the inferencer could figure out the types
then the checker could determine whether the program is well-typed),
but in practice they are often merged into a single procedure
called type reconstruction.

OCaml type reconstruction

At a very high level, the algorithm works as follows:

Determine the types of definitions in order, using the types of
earlier definitions to infer the type of later ones.
(Which is one reason you may not use a name before it is bound in an OCaml program.)

For each let definition, analyze the definition to determine 
constraints about its type. For example, if the inferencer sees
x + 1, it concludes that x must have type int. It gathers similar
constraints for function applications, pattern matches, etc.

The OCaml type reconstruction algorithm attempts to never reject
a program that could type check, if the programmer had written down
types. It also attempts never to accept a program that cannot
possibly type check. Some more obscure parts of the language
can sometimes make type annotations either necessary or at least
helpful. But for most code, type annotations really are
completely optional.

OCaml uses an algorithm(does it?) called Hindley Milner invented
independently by Roger Hindley and Robin Milner.

The history of Hindley Milner

Hindley Milner was rediscovered many times by many people.
Curry used it informally in the 1950's. He wrote it up 
formally in 1967(published 1969). Hindley discovered it
independently in 1969; Morris in 1968; and Milner and 1978.
In the realm of logic, similar ideas go back perhaps as far as
Tarski in the 1920's.

Efficiency of Hindley Milner

It is usually very efficiente, in practice, it runs in
approximately liner time. But in theory, there are some
very strange programs that can adcuse its running-time
to blow up.(Technically, it's exponential time).

Let's build up to the Hindley Milner type inference
algorithm by starting with this little language:

expr ::= 
    x 
  | integer
  | bool
  | expr1 binop expr2
  | if expr1 then expr2 else expr3
  | fun x -> expr
  | expr1 expr2

binop ::=
    +
  | *
  | <=

type ::=
    int
  | bool
  | type1 -> type2

Since anonymousfunctions in this language do not have type
annotations, we have to infer the type of the argument x.

For example:

In fun x -> x + 1, argument x must hae type int hence the
function has type int -> int.

In fun x -> if x then 1 else 0, argument x must have type bool
hence the function must have type bool -> int.

Function fun x -> if x then x else 0 is untypeable, because
it would require x to have type both bool and int, which isn't allowed.

A syntactic simplification

We can treat expr1 binop expr2 as syntactic sugar for (binop) expr1 expr1.
That is, we treat infix binary operators as prefix function
application. Let's introduce a new syntatic class names for names, which
generalize identifiers and operators. That changes the syntax to:

expr ::= 
    x 
  | integer
  | bool
  | expr1 binop expr2
  | if expr1 then expr2 else expr3
  | fun x -> expr
  | expr1 expr2

binop ::=
    ( + )
  | ( * )
  | ( <= )

name := 
    x
  | binop

type ::=
    int
  | bool
  | type1 -> type2

We already know the types of those built-in operators:

( + ): int -> int -> int
( * ): int -> int -> int
( <= ): int -> int -> bool

Constraint-based inference

How would you mentally infer the type of fun x -> 1 + x,
or rather fun x -> ( + ) 1 x? We could break it down into pieces:

Start with x having some unkown type t

Note that ( + ) is known to have type int -> int -> int.

So its first argument must have type int. Which 1 does.

And its second argument must have type int, too. So t = int.
That is a constraint on t.

Finally the body of the function must also have type int,
since that's the return type of ( + ).

Therefore the type of the entire function must be t -> int.

Since t = int, that type is int -> int

The type inference algorithm follows the same idea of generating
unknown types, collecting constraints on them,
and using the constraints to solve for the type of the expression.

Inference relation

Let's introducde a new 4-ary relation Γ ⊢ expr : type ⊣ C,
which should read as follows: in environment Γ, expression expr
is inferred to have type type and generates constraint set C.
A constraint is an equation of the form type1 = type2 for any types
type1 and type2.

If we think of the relation as a type-inferece function, the colon
in the middle separates the input from the output. The inputs are
Γ and expr: we want to know what the type of expr is in environment
Γ. The function returns as output a type type and constraints C.

Inference of constants and names

Γ ⊢ integer : int ⊣ {}

Γ ⊢ bool : bool ⊣ {}

We already know their types and there are no constraints generated.

Inferring the type of a name required looking it up in the
environment:

Γ ⊢ name : Γ(name) ⊣ {}

No constraints are generated.

If the name is not bound in the environment, the expression
cannot be typed. It's an unbound name error.

Inference of if expressions

The remaining rules are at their core the same as the-type
checking rules we saw previously, but they each generate
a type variable and possibly some constraints on that type
variable.

Here's the if rule:

Γ ⊢ if expr1 then expr2 else expr3 : 'type ⊣ C1, C2, C3, type1 = bool, 'type = type2, 'type = type3
  if fresh 'type
  and Γ ⊢ expr1 : type1 ⊣ C1
  and Γ ⊢ expr2 : type2 ⊣ C2
  and Γ ⊢ expr3 : type3 ⊣ C3

To infer the type of an if, we infer the types type1, type2, and type3 of
each of its subexpressions, along with any constraints on them.
We do know that the type of the guard must be bool, so we
generate a constraint that type1 = bool.

Furthermore, we know that both branches must have the same type --
through, we don't know in advance what that type might be.
So, we invent a fresh type vsariable 'type to stand for that type.
A type variable is fresh if it has never been used elsewhere
during type inference. So, picking a fresh type variable
just means picking a new name that can't possibly be confused
with any other names in the program. We return 'type as the type
of the if, and we record two constraints 'type = type2 and
'type = type3 to say that both branches must have that type.

We therefore need to add type variables to the syntax of types:

type ::=
    'x
  | int
  | bool
  | type1 -> type2

Example

{} ⊢ if true then 1 else 0 :' type ⊣ bool = bool 'type = int
  {} ⊢ true : bool ⊣ {}
  {} ⊢ 1 : int ⊣ {}
  {} ⊢ 0 : int ⊣ {}

Inference of functions and applications

Anonymous functions: since there is no type annotation on x,
its type must be inferred:

Γ ⊢ fun x -> expr : 'type1 -> type2 ⊣ C
  if fresh 'type1
  and Γ ⊢ x : 'type1, expr : type2 ⊣ C

We introduce a fresh type variable 'type1 to stand for the type
of x, and infer the type of body expr undere the environment
in which x : 'type1. Wherever x is used in expr, that can cause
constraints to be generated involving 'type1.
Those constraints will become part of C.

Example:

{} ⊢ fun x -> if x then 1 else 0 : 'type1 -> 'type2 ⊣ 'type1 = bool 'type2 = int
  {}, x : 'type1 ⊢ if x then 1 else 0 : 'type2 ⊣ 'type1 = bool, 'type2 = int
  {}, x : 'type1 ⊢ x : 'type1 ⊣ {}
  {}, x : 'type1 ⊢ 1 : int ⊣ {}
  {}, x : 'type1 ⊢ 0 : int ⊣ {}

The inferred type of the function is 'type1 -> 'type2, with
constraints 'type1 = bool and 'type2 = int.
Simplifying that, the function's type is bool -> int.

Function application: the type of the entire application
must be inferred, because we don't yet know anything
about th types of either subexpression:

Γ ⊢ expr1 expr2 : 'type ⊣ C1, C2, type1 = type2 -> 'type
  if fresh 'type
  and Γ ⊢ expr1 : type1 ⊣ C1
  and Γ ⊢ expr2 : type2 ⊣ C2

We introduce a fresh type variable 'type for the type of
the application expression. We use inference to determine
the types of the subexpressions and any constraints they
happen to generate. We add one new constraint,
type1 = type2 -> 'type, which expresses that the type
of the left-hand side expr1 must be a function that takes an
argument of type2 and returns a value of type 'type.

Example:

Let I be the initial environment that binds the boolean operators.
Let's infer the type of a partial application of ( + ):

I ⊢ ( + ) 1 : 'type ⊣ int -> int -> int = int -> 'type
  I ⊢ ( + ) : int -> int -> int ⊣ {}
  I ⊢ 1 : int ⊣ {}

From the resulting constraint we see that

int -> int -> int
=
int -> 'type

Stripping the int -> off the left-hand side of each of those
function types, we are left with

int -> int
=
'type

Hence the type of ( + ) 1 is int -> int

Solving constraints

What does it mean to solve a set of constraints? Since constraints
are equations on types, it's much like solving a system
of equations in algebra. We want to solve for the values of the
variables appearing in those equations. By substituting those values
for the variables, we should get equations that are identical on
both sides. For example, in algebra we might have:

5x + 2y = 9
x - y = -1

Solving that system, we'd get that x =1 and y = 2. 
If we substitute 1 for x and 2 for y, we get:

(1) + 2(2) = 9
1 - 2 = - 1

which reduces to

9 = 9
-1 = -1

In programming languages terminology, we say that the
substitution {1/x} and {2/y} together unify that set
of equations, because htye make each equation unite such that
its left side is identical to its right side.

Solving systems of equations on types is similar.
Just as we found numbers to substitute for variables above,
we now wnat to find types to substitute for type variables,
and thereby unify the set of equations.

Type substitutions

Much like the substitutions we defined before the substitution
model of evaluation, we'll write {type / 'type} for the type
substituion that maps type variable 'type to type type.
For example, 
{type2 / 'type} type1 means type1 with type2 substituted for 'type.

We can define substitution on types as follows:

int {type / 'x} = int

bool {type / 'x} = bool

'x {type / 'x} = type

'y {type / 'x} = 'y

(type1 -> type2) {type / 'x} = (type1 {type / 1x}) -> (type2 { type / 'x})

Given two substitutions S1 and S2, we write S1; S2 to mean the
substitution that is their sequential composition, which
is defined as follows:

type (S1; S2) = (type S1) S2

Unification

A substitution unifies a constraint type1 = type2 if type1 S
results in the same as type2 S. For example,
substitution S = {int -> int / 'y}; {int / 'x} unifies
constraint 'x -> ('x -> int) = int -> 'y because

('x -> ('x -> int)) S
=
(int -> (int -> int))

and 

(int -> 'y) S
=
(int -> (int -> int))

A substitution S unifies a set C of constraints if S
unifies every constraint in C.

The unification algorithm

To solve a set of constraints we must find a substitution
that unifies the set. That is, we need to find a sequence
of maps from type variables to types,
such that the sequence causes each equation in the constraint
set to unite, meaning that its left-hand side
and right-hand side become the same.

To find a substitution that unifies constraint set C, we use an
algorithm unify, which is defined as follows:

If C is the empty set, then unify(C) is the empty substitution.

If C contains at least one constraint type1 = type2 and possibly
some other constraints C', then unify(C) is defined as follows:

If type1 and type2 are both the same simple type -- i.e.,
both the same type variable 'x or both int or both bool --
then return unify(C'). In this case, the constraint
contained no useful information, so we're tossing it out
and continuing.

If type' is a type variable 'x and 'x does not occur in type2,
then let S = {type2 / 'x}, and return S; unify(C' S).
In this case, we are eliminating the variable 'x from the
system of equations.

If type2 is a type variable 'x and 'x does not occur in type1,
then let S = {type1 / 'x}, and return S; unify(C' S).
This is just like the previous case.

If type1 = i1 -> o1 and type2 = i2 -> o2 where i1, i2, o1 and o2 are types,
then unify(i1 = i2, o1 = o2, C'). In this case we break one constraint
down into two smaller constraints and add those constraints back
in to be further unified.

Otherwise, fail. There is no possible unifier.

Example:

Let's infer the type of the following expression:

fun f -> fun x -> f (( + ) x 1)

Constraint generation

We start in the initial environment I that, among other things,
maps ( + ) to int -> int -> int

I ⊢ fun f -> fun x -> f (( + ) x 1) 

Since we have a function, we use the function rules for inference
to proceed by introducing a fresh type variable for the argument:

I ⊢ fun f -> fun x -> f (( + ) x 1) 
  I, f : 'a ⊢ fun x -> f (( + ) x 1) 

Again we have a function, hence a fresh type variable:

I ⊢ fun f -> fun x -> f (( + ) x 1) 
  I, f : 'a, x : 'b ⊢ f (( + ) x 1)

Now we have an application application. Before dealing with it,
we need to descend into its subexpressions. The first one is easy,
it's just a variable. So we finally can finish a judgement with
the variable's type from the environment, and an empty constraint set.

I ⊢ fun f -> fun x -> f (( + ) x 1) 
  I, f: 'a, x: 'b ⊢ f : 'a ⊣ {}
    I, f: 'a, x: 'b ⊢ ( + ) x 1 
      I, f: 'a, x: 'b ⊢ ( + ) x 
        I, f: 'a, x: 'b ⊢ ( + ) : int -> int -> int ⊣ {}
        I, f: 'a, x: 'b ⊢ x : 'b ⊣ {}
      I, f: 'a, x: 'b ⊢ ( + ) x: 'c ⊣ int -> int -> int = 'b -> 'c
*)
open Ast
open Typechecker

let parse (s: string): expression = 
  let lexbuf = Lexing.from_string s in
  let ast = Parser.program Lexer.read lexbuf in 
  ast

let () = 
  "fun f -> fun x -> (f (x + 1)) + 1" |> parse |> typecheck;
