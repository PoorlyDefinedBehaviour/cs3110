(*
In the functor syntax we've been using:

module F (M: S) = struct 
  ...
end 

the type annotation : S and the parentheses around it,
(M : S) are required. The reason why is that type inference
of the signature of a functor input is not supported.

Much like functions, functors can be written anonymously.
The following two syntaxes for functors are equivalent:

module F (M : S) = struct 
  ...
end

module F = functor (M : S) -> struct 
  ...
end
*)

let _ =