type 'a tree = 
  | Leaf 
  | Node of 'a node 
and 
  'a node = {
    value: 'a;
    left: 'a tree;
    right: 'a tree;
  }

let rec size = function 
  | Leaf -> 0
  | Node {left; right; _} -> 1 + size left + size right

let rec height = function 
  | Leaf -> 0
  | Node {left; right; _} -> 1 + max (height left) (height right)

let rec mem x = function 
  | Leaf -> false
  | Node {value; left; right} -> value = x || mem x left || mem x right

(* time is O(n²) because of the concat operator @ which is O(n) *)
let rec quadratic_preorder = function 
  | Leaf -> []
  | Node {value; left; right} -> [value] @ quadratic_preorder left @ quadratic_preorder right

(* time is O(n) because :: is O(1) *)
let preorder t =
  let rec go acc = function 
    | Leaf -> acc 
    | Node {value; left; right} -> value :: (go (go acc right) left)
    in go [] t

let _ =
  let t = Node {
    value = 2;
    left = Node {value = 1; left = Leaf; right = Leaf};
    right = Node {value = 3; left = Leaf; right = Leaf};
  } in
    print_endline (string_of_int (size t));
    print_endline (string_of_int (height t));
    print_endline (string_of_bool (mem 2 t));
    print_endline (string_of_bool (mem 5 t));
    print_endline (string_of_int (List.hd (quadratic_preorder t)));
    print_endline (string_of_int (List.hd (preorder t)));