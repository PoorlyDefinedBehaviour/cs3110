(*
The expression assert e evaluates e.
If the result is true, nothing more happens, 
and the entire expression evaluates 
to a special value called unit.
The unit value is written () and its type is unit.
But if the result is false, an exception is raised.
*)
let _ =
  assert true;
  assert (2 + 2 == 4);
  assert (2 + 2 == 3); (* raises exception *)