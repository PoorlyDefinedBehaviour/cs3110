(* 
  This defines x to be 42, after which we can use x
  in future definitions at the toplevel. 
  We'll call this use of let a let definition.
*)
let x = 42

let _ = 
  (* There's another use of let which is as an expression: *)
  let y = 42 in y + 1

  

  