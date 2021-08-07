open Ast
(*
Evaluating the AST

We'll define evaluation with a mathematical notation:

The first, -->, will represent how a program takes
one single step of execution.

The second, -->*, will represent how a program takes
multiple steps of execution.

The third, ==>, abstracts away from all the details
of single steps and represents how a program
reduces directly to a value

A value is an expression for which there is no computation
remaining to be done.

The style in which we are defining evaluation with these
relations is known as operational semantics, because
we're using the relations to specify how the machine
operates as it evaluates programs. There are two other
majos styles, known as denotational semantics and
axiomatic semantics.

Variables

There are two different ways to think about the implementation
of variables:

We could eagerly substitute the value of a variable for its name
throughout the scope of that name, as soon as we find a 
binding of the variable.

We could lazily record the substitution in a dictionary,
which is usually called an environment when used for this purpose,
and we could look up the variable's value in that environment
whenever we find its name mentioned in a scope.

Those ideas lead to the substitution model of evaluation and
the environment model of evaluation.
The substitution model tends to be nicer to work with mathematically,
whereas the environment model tends to be more similar to how
an interpreter is implemented.

For each of the syntactic forms that a SimPL expression could have,
we'll now define some evaluation rules, which constitute an
inductive definition of the --> relation. Each rule will have
the form e --> e', meaning that e takes a single step to e'.

Constants

Integer and Boolean constants are already values, 
so they cannot take a step.

Let's introduce another notation:

e -/-> means there does not exist an e' such that e --> e'.

Examples:

integer -/-> 
bool -/->

Binary operators

A binary operator application expression1 binary_operator expression2
has two subexpressions, expression1 and expression2.

The OCaml language definition says that(for non-short-circuit operators)
it is unspecified which side of the operator is evaluated first.
The current implementation happens to evaluate the right-hanbd side first.

Let's define left-to-right evaluation, using the --> relation for that:

We start by saying that the left-hand side can take a step:

expression1 binary_operator expression2 -> expression1' binary_operator expression2
  if expression1 -> expression1'
  
If the left-hand side is finished evaluation, then the right-hand side may
begin stepping:

value1 binary_operator expression2 --> value1 binary_operator expression2'
  if expression2 --> expression2'

Finally when both sides have reached a value, the binary operator may be applied:

value1 binary_operator value2 --> value3
  if value3 is the result of primitive operation value1 binary_operator value2

By primitive operation, we mean that there is some underlying notion
of what binary_operator actually means.
For example, the character + is just a piece of syntax, but we
are conditioned to understand its meaning as an arithmetic addition
operation. The primitive operation typically is something implemented
by hardware(e.g., an ADD opcode), or by a run-time library(e.g., a pow function).

Here's an example taking single steps using the binary operator rule:

(3 * 1000) + ((1 * 100) + ((1 * 10) + 0))
--> 3000 + ((1 * 100) + ((1 * 10) + 0))
--> 3000 + (100 + ((1 * 10) + 0))
--> 3000 + (100 + (10 + 0))
--> 3000 + (100 + 10)
--> 3000 + 110
--> 3110

If expressions

First, the condition is evaluated to a value:

if expression1 then expression2 else expression3
--> if expression1' then expression2 else expression3
      if expression1 --> expression1'

Then, based on the guard, the if expression is simplified to just
one of the branches:

if true then expression2 else expression3 -> expression2

if false then expression2 else expression3 -> expression3

Let expressions

Let's make SimPL let expressions evaluate in the same way as 
OCaml let expressions: first the binding expression, then the body.

The rule that steps the binding expression is:

let x = expression1 in expression2 --> let x = expression1' in expression2
  if expression1 --> expression1'

Next, if the binding expression has reached a value, we want
to substitute that value for the name of the variable in the
body expression:

let x = value1 in expression2 --> expression2 with value1
substituted for x

For example, let x = 42 in x + 1 should step to 42 + 1,
because substituting 42 ifor x in x + 1 yields 42 + 1.

We need to formally define what substitute means.
It turns out to be rather tricky. So, rather than getting
side-tracked by it right now, let's assume a new notation:

e'{e/x}, which means, the expression e' with e substituted for x.

For now, we can add this rule:

let x = value1 in expression2 --> expression2{value1/x}

Variables

Note how the let expression rule eliminates a variable from
showing up in the body expression: the variable's name is replaced
by the value that variable should have. So, we should never
reach the point of attempting to step a variable name -- assuming
that the program was well typed.
*)
let is_value expression = 
  match expression with 
  | Int _ | Bool _ -> true 
  | Var _ | Let _ | Binary _ | If _ -> false

(**
[subst expression value x] is [expression{value/x}]

Defining substitution

Constants have no variables appearing in them
(e.g., x cannot syntactically occur in 42),
so substitution leaves them unchanged:

integer{e/x} = integer
bool{e/x} = bool

For binary operators and if expressions,
all that substitution needs to do is to recurse
inside the subexpressions:

(e1 binop e2){e/x} = e1{e/x} binop e2{e/x}

(if e1 then e2 else e3){e/x} = if e1{e/x} then e2{e/x} else e3{e/x}

Variables

There are two possibilities: either we encounter the variable x
, which means we should do the substitution, or we encounter
some other variable with a different name, say y, in which
case we should not do the substitution:

x{e/x} = e
y{e/x} = y  

Example:

Suppose we wre trying to figure out the result of
(x + 42){1/x}

(x + 42){1/x}
= x{1/x} + 42{1/x}
= 1 + 42{1/x}
= 1 + 42
= 43
*)
let rec subst expression value x = 
  match expression with 
  | Var(y) -> if x = y then value else expression
  | Bool(_) -> expression
  | Int(_) -> expression
  | Binary(operator, e1, e2) -> Binary(operator, subst e1 value x, subst e2 value x)
  | Let(y, e1, e2) ->
      let e1' = subst e1 value x in
      if x = y then 
        Let(y, e1', e2)
      else 
        Let(y, e1', subst e2 value x)
  | If(e1, e2, e3) ->
      If(subst e1 value x, subst e2 value x, subst e3 value x)

(**
[small_step] is the [-->] relation, that is, a single step
of evaluation.
*)
let rec small_step expression = 
  match expression with 
  | Int _ | Bool _ -> failwith "Does not step"
  | Var _ -> failwith "Unbounded variable"
  | Binary(operator, e1, e2) when is_value e1 && is_value e2 ->
      small_step_binary_operation operator e1 e2 
  | Binary(operator, e1, e2) when is_value e1 ->
      Binary(operator, e1, small_step e2)
  | Binary (operator, e1, e2) ->
      Binary(operator, small_step e1, e2)
  | Let(identifier, e1, e2) when is_value e1 -> subst e2 e1 identifier
  | Let(identifier, e1, e2) -> Let(identifier, small_step e1, e2)
  | If(Bool(true), e2, _) -> e2
  | If(Bool(false), _, e3) -> e3 
  | If(Int _, _, _) -> failwith "If condition must have type bool"
  | If(e1, e2, e3) -> If(small_step e1, e2, e3)
and 
  small_step_binary_operation operator e1 e2 = 
    match (operator, e1, e2) with 
    | (Add, Int(a), Int(b)) -> Int(a + b)
    | (Multiply, Int(a), Int(b)) -> Int(a * b)
    | (LessThanOrEqual, Int(a), Int(b)) -> Bool(a <= b)
    | _ -> failwith "Operator and operand type mismatch"

(*
The Multistep Relation

Now that we've define -->, there's really nothing left to do
to define -->*. It's just the reflexive transitive closure
of -->. In other other, it can be defined with just these
two rules:

e -->* e

e -->* e''
    if e --> e' --> and e' -->* e''

Defining the Big-Step relation

Constants are easy, because they big-step themselves:

integer ==> integer

bool ==> bool

Binary operators just big-step both of their subexpressions,
then apply whatever the primitive operator is:

e1 binop e2 ==> v
  if e1 ==> v1
  and e2 ==> v2
  and v is the result of primitive operation v1 binop v2

If expressions big step the condition, then big step one of the branches:

if e1 then e2 else e3 ==> v2
  if e1 ==> true
  and e2 ==> v2

if e1 then e2 else e3 ==> v3
  if e1 ==> false
    and e3 ==> v3

Let expressions big step the binding expression, do a substitution,
and big step the result of the substitution

let x = e1 in e2 ==> v2
  if e1 ==> v1
  and e2{v1/x} ==> v2

Finally, variables do not big step, for the same reason as with
the small step semantics -- a well-typed program will never
reach the point of attempting to evaluate a variable name:

x =/=>
*)
(**
[big_step] is the ==>] relation, that is, takes multiple
steps until a value is produced.
*)
let rec big_step expression =
  match expression with 
  | Int _ | Bool _ -> expression 
  | Var _ -> failwith "Unbounded variable"
  | Binary(operator, e1, e2) -> 
      big_step_binary_operation operator (big_step e1) (big_step e2)
  | If(condition, e1, e2) -> big_step_if condition e1 e2
  | Let(x, e1, e2) -> subst e2 (big_step e1) x |> big_step
and
  big_step_binary_operation operator e1 e2 = 
  match (operator, e1, e2) with 
  | (Add, Int(a), Int(b)) -> Int(a + b)
  | (Multiply, Int(a), Int(b)) -> Int(a * b)
  | (LessThanOrEqual, Int(a), Int(b)) -> Bool(a <= b)
  | _ -> failwith "Operator and operand type mismatch"
and
  big_step_if condition consequence alternative =
  match big_step condition with 
  | Bool(true) -> big_step consequence
  | Bool(false) -> big_step alternative 
  | _ -> failwith "If condition must have type bool"