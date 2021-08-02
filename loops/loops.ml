(*
OCaml has while and for loops. Their syntax is as follows:

while e1 do e2 done 

for x = e1 to e2 do e3 done 

for x = e1 downto e2 do e3 done

They do what you would expect and always evaluate to ()
*)

let _ =
  for x = 1 to 5 do 
    print_endline (string_of_int x);
  done;

  for x = 5 downto 1 do 
    print_endline (string_of_int x);
  done;

  let x = ref 0 in 
  while !x < 5 do 
    print_endline (string_of_int !x);
    x := !x + 1;
  done;