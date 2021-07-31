let length xs = List.fold_left (fun acc _ -> acc + 1) 0 xs 

let reverse xs = List.fold_left (fun acc x -> x :: acc) [] xs

let pp_list xs = 
  let elements = xs 
    |> List.map string_of_int
    |> String.concat "; "
  in 
    "[" ^ elements ^ "]"

let map f xs = List.fold_right (fun x acc -> (f x) :: acc) xs []

let filter f xs = List.fold_right (fun x acc -> if f x then x :: acc else acc) xs []

let _ =
  length [1; 2; 3] |> string_of_int |> print_endline;
  reverse [1; 2; 3] |> pp_list |> print_endline;  
  map (fun x -> x + 1) [1; 2; 3] |> pp_list |> print_endline;  
  filter (fun x -> x mod 2 = 0) [1; 2; 3] |> pp_list |> print_endline;  