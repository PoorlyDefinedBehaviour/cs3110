(* module type Mystack = sig ... end is not required *)

type 'a t

val empty: 'a t

val is_empty: 'a t -> bool 

val push: 'a -> 'a t -> 'a t

val peek: 'a t -> 'a option 

val pop: 'a t  -> 'a t