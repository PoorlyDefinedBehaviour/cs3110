(*
A record is a kind of type in OCaml that programmers can define.
It is a composite of other types of data, each of which is named.
OCaml records are much like structs in C.

Syntax

A record expression is written:

{f1 = e1; ...; fn = en}

The order of fi = e1 inside a record is expression is irrelevant.
For example {f = e1; g = e2} is entirely equivalent to
{g = e2; f = e1}.

A field access is written:

e.f

where f is an identifier of a field name, not an expression.

Dynamic semantics

If for all i in 1..n, it holds that ei ==> vi, then
{f1 = e1; ...; fn = en} ==> {f1 = v1; ...; fn = vn}

if e ==> {...; f = v; ...} then e.f ==> v

Static semantics

A record type is written:

{f1: t1; ...; fn: tn}

The order of the fi: ti inside a record type is irrelevant.
FOr example, {f: t1; g: t2} is entirely equivalent to
{g: t2; f: t1}.

Record types must be defined before they can be used.
This enables OCaml to do better type inference than would
be possible if record types could be used without definition.

Type-checking rules:

if for all i in 1..n, it holds that ei: ti, and if
t is deifned to be {f1: t1;...; fn: tn}, then
{f1 = e1; ...; fn = en} : t

Note: the set of fields provided in a record expression
must be the full set of fields defined as part of the record's type.

If e: t1 and if t1 is defined to be {...; f: t2; ...} then e.f : t2

Record copy

Another syntax is aldo provided to construct a new record out
of an old record:

{e with f1 = e1; ...; fn = en}

As usual, this doesn't mutate the old record, it constructs
a new one with new values.
*)
type pokemon = {
  name: string;
  hp: int;
}

(* We can pattern match on records *)
let f pokemon =
  match pokemon with
  | {name="Charmander"; _} -> "something"
  | {name="Pikachu"; _} -> "something else"
  | _ -> "nothing"

let _ =
  let my_pokemon = {name = "Charmander"; hp = 39} in
    Format.printf "%s has %dhp\n" my_pokemon.name my_pokemon.hp;

  print_endline (f my_pokemon);
