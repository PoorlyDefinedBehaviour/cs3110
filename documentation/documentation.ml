(*
OCaml provides a tool called OCamldoc that works a lot
like Java's Javadoc tool: it extracts specially formatted
comments from source code and renders them as HTML.
*)

(* 
The double asterisk is what causes the comment to be
recognized as an OCamldoc comment.
*)
(** [add x y] is the sum of two numbers **)
let add = (+)

let _ =
  print_endline (string_of_int (add 2 2));
