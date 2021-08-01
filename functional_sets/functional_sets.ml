module type Set = sig
  type 'a t 

  val empty: 'a t

  val mem: 'a -> 'a t -> bool 

  val add: 'a -> 'a t -> 'a t 

  val elements: 'a t -> 'a list
end

module ListSet: Set = struct 
  type 'a t = 'a list 

  (* time O(1) *)
  let empty = [] 

  (* time O(n) *)
  let mem x set = List.mem x set

  (* time O(n) *)
  let add x set = 
    if mem x set then 
      set 
    else 
      x :: set
    
  (* time O(1) *)
  let elements set = set
end

module ListSetDups: Set = struct 
  type 'a t = 'a list 

  (* time O(1) *)
  let empty = [] 

  (* time O(n) *)
  let mem x set = List.mem x set

  (* time O(1) *)
  let add x set = x :: set 

  (* 
  Only remove duplicates when set elements are requested 
  time O(n log n)? 
  *)
  let elements set = List.sort_uniq Stdlib.compare set
end

let pp_list xs = 
  let elements = xs 
    |> List.map string_of_int
    |> String.concat "; "
  in 
    "[" ^ elements ^ "]"

let _ =
  ListSet.empty 
  |> ListSet.add 1
  |> ListSet.add 1
  |> ListSet.add 2
  |> ListSet.elements 
  |> pp_list 
  |> print_endline; (* [2; 1] *)

  ListSetDups.empty 
  |> ListSetDups.add 1
  |> ListSetDups.add 1
  |> ListSetDups.add 2
  |> ListSetDups.elements 
  |> pp_list 
  |> print_endline; (* [1; 2] *)