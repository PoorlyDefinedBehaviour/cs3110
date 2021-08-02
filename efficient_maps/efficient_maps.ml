module type Map = sig 
  type ('k, 'v) t

  val insert: 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t

  val find: 'k -> ('k, 'v) t -> 'v option 

  val remove: 'k -> ('k, 'v) t -> ('k, 'v) t

  val empty: ('k, 'v) t

  val keys: ('k, 'v) t -> 'k list
end


module ListMap: Map = struct 
  type ('k, 'v) t = ('k * 'v) list

  (* 
  time O(1) 
  space O(1)
  *)
  let insert key value map = (key, value) :: map 

  (* 
  time O(n) 
  space O(1)
  *)
  let find = List.assoc_opt

  (* 
  time O(n) 
  space O(n)
  *)
  let remove key map =
    List.filter (fun (key', _) -> key' <> key) map

  (* 
  time O(1) 
  space O(1)
  *)
  let empty = []

  (* 
  time O(n log n) 
  space O(n)
  *)
  let keys map = map |> List.map fst |> List.sort_uniq Stdlib.compare
end

module type DirectAddressMap = sig 
  type 'v t

  val insert: int -> 'v -> 'v t -> unit 

  val find: int -> 'v t -> 'v option 

  val remove: int -> 'v t -> unit 

  val create: int -> 'v t
end

module ArrayMap: DirectAddressMap = struct 
  type 'v t = 'v option array

  (*
  time O(1)
  space O(1)
  *)
  let insert key_index value array = array.(key_index) <- Some value

  (*
  time O(1)
  space O(1)
  *)
  let find key_index array = array.(key_index)

  (*
  time O(1)
  space O(1)
  *)
  let remove key_index array = array.(key_index) <- None

  (*
  time O(n)
  space O(n)
  *)
  let create size = Array.make size None
end

let string_of_opt opt = 
  match opt with 
  | None -> "None"
  | Some value -> Format.sprintf "Some(%s)" value

let pp_list xs = 
  let elements = xs 
    |> List.map string_of_int
    |> String.concat "; "
  in 
    "[" ^ elements ^ "]"

let _ =
  let map = 
    ListMap.empty
    |> ListMap.insert 1 "one"
    |> ListMap.insert 2 "two"
    |> ListMap.insert 3 "three"
  in 
    print_endline (string_of_opt (ListMap.find 2 map)); (* Some(two) *)
    print_endline (pp_list (ListMap.keys map)); (* [1; 2; 3] *)
  
  let map = ArrayMap.create 10 in 
  ArrayMap.insert 1 "one" map;
  ArrayMap.insert 2 "two" map;
  ArrayMap.insert 3 "three" map;
  print_endline (string_of_opt (ArrayMap.find 3 map)); (* Some(three) *)
  print_endline (string_of_opt (ArrayMap.find 5 map)); (* None *)
  

