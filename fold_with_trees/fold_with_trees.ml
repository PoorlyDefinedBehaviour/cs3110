type 'a tree = 
  | Leaf 
  | Node of 'a * 'a tree * 'a tree

let rec fold_right zero f = function 
  | Leaf -> zero 
  | Node (value, left, right) -> f value (fold_right zero f left) (fold_right zero f right)

let size = fold_right 0 (fun _ left_size right_size -> 1 + left_size + right_size)

let depth = fold_right 0 (fun _ left_depth right_depth -> 1 + max left_depth right_depth)

let preorder = fold_right [] (fun value left_folded right_folded -> value :: left_folded @ right_folded)

let pp_list xs = 
  let elements = xs 
    |> List.map string_of_int
    |> String.concat "; "
  in 
    "[" ^ elements ^ "]"

let _ =
  let t = 
    Node(1, 
      Node(2, Leaf, Leaf),
      Node(3, Leaf, Leaf)
    )
  in 
    size t |> string_of_int |> print_endline;
    depth t |> string_of_int |> print_endline;
    preorder t |> pp_list |> print_endline;
