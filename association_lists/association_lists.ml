(*
A dictionary is a data structure that maps keys to values.

One easy implementation of a dictionary is an association
list, which is a list of pairs.

Example of an association list:

let d = [ ("rectangle", 4); ("triangle", 3); ("dodecagon", 12) ] 

The OCaml standard library has functions to deal with association lists
lists such as List.assoc
*)

(* time O(1) *)
let insert key value association_list = (key, value) :: association_list

(* time O(n) *)
let rec lookup key = function 
  | [] -> None 
  | (key', value) :: tail ->
    if key = key' then  
      Some value
    else 
      lookup key tail

exception Unwrap_called_on_none

let unwrap = function 
  | None -> raise Unwrap_called_on_none
  | Some value -> value

let _ =
  let association_list = 
    []
    |> insert "key_a" "value_a"
    |> insert "key_b" "value_b" 
    in
    print_endline (unwrap (lookup "key_a" association_list))
  
    
    