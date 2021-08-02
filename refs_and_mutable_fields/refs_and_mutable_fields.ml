(*
It turns out that refs are actually implemented as mutable fields.
In Stdlib we find the following declaration:

type 'a ref = {
  mutable contents: 'a;
}

The other syntax we've seen for refs is in fact equivalent
to simple OCaml functions:

val ref: 'a -> 'a ref

val ( ! ): 'a ref -> 'a

val ( := ): 'a ref -> 'a -> unit

The reason we say equivalent is that hose functions
are actually implemented not in OCaml but in the OCaml run-time,
which is implemented mostly in C. But the functions behave the same
as the OCaml sourve given above.

Here's how the OCaml source code looks like for refs:

-- stdlib.mli --

type 'a ref = { mutable contents : 'a }
(** The type of references (mutable indirection cells) containing
   a value of type ['a]. *)

external ref : 'a -> 'a ref = "%makemutable"
(** Return a fresh reference containing the given value. *)

external ( ! ) : 'a ref -> 'a = "%field0"
(** [!r] returns the current contents of reference [r].
   Equivalent to [fun r -> r.contents].
   Unary operator, see {!Ocaml_operators} for more information.
*)

external ( := ) : 'a ref -> 'a -> unit = "%setfield0"
(** [r := a] stores the value of [a] in reference [r].
   Equivalent to [fun r v -> r.contents <- v].
   Right-associative operator, see {!Ocaml_operators} for more information.
*)

external incr : int ref -> unit = "%incr"
(** Increment the integer contained in the given reference.
   Equivalent to [fun r -> r := succ !r]. *)

external decr : int ref -> unit = "%decr"
(** Decrement the integer contained in the given reference.
   Equivalent to [fun r -> r := pred !r]. *)

-- stdlib.ml --

type 'a ref = { mutable contents : 'a }
external ref : 'a -> 'a ref = "%makemutable"
external ( ! ) : 'a ref -> 'a = "%field0"
external ( := ) : 'a ref -> 'a -> unit = "%setfield0"
external incr : int ref -> unit = "%incr"
external decr : int ref -> unit = "%decr"
*)

let _ =