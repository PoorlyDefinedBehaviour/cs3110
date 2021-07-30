type 'a tree = 
  | Leaf 
  | Node of 'a * 'a tree * 'a tree

let rec size = function 
  | Leaf -> 0
  | Node(_, left, right) -> 1 + size left + size right

let _ =
  let t =
    Node(4, 
      Node(2, 
        Node(1, Leaf, Leaf),
        Node(3, Leaf, Leaf)
      ),
      Node(5,
        Node(6, Leaf, Leaf),
        Node(7, Leaf, Leaf)
      )
    ) in 
    print_endline (string_of_int (size t));