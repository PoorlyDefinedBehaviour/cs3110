module type Set = sig 
  type 'a t

  val empty: 'a t

  val mem: 'a -> 'a t -> bool 

  val add: 'a -> 'a t -> 'a t

  val elements: 'a t -> 'a list
end

module ListSetDups: Set = struct 
  type 'a t = 'a list

  let empty = []

  let mem = List.mem 

  let add x set = x :: set

  let elements set = List.sort_uniq Stdlib.compare set
end

module ListSetDupsExtended: Set = struct 
  (*
  OCaml provides a language feature called includes that enables
  code reuse. It enables a structure to include all the values
  defined by another structure, or a signature to include all
  the names declared by another signature.
  *)
  include ListSetDups
  
  let of_list lst = List.fold_right add lst empty

  (* 
  Common misconception

  We can provide a new implementation of one of the 
  included functions but it does not replace the original 
  implementation. If any ode inside ListSetDups called that
  original implementation, it still would in ListSetDupsExtended.
  *)
  let elements set = 
    let rec go xs set =
      match set with 
      | [] -> xs
      | head :: tail ->
        if mem head xs then 
          go xs tail
        else 
          go (head :: xs) tail
    in go empty set
end

let pp_list xs = 
  let elements = xs 
    |> List.map string_of_int
    |> String.concat "; "
  in 
    "[" ^ elements ^ "]"

let _ =
  ListSetDupsExtended.empty 
  |> ListSetDupsExtended.add 1
  |> ListSetDupsExtended.add 1
  |> ListSetDupsExtended.add 2
  |> ListSetDupsExtended.elements 
  |> pp_list 
  |> print_endline; (* [1; 2] *)