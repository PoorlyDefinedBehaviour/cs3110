(*
Red-black trees are a relatively simple balanced binary tree
data structure. The ideia is to strengthen the representation
invariant so a tree has height logarithmic in the number
of nodes n. To help enforce the invariant, we color each
node of the tree either red or black. Where it matters,
we consider the color of an empty tree to be black.

Here are the new conditions we add to the binary search
tree representation invariant:

There are no two adjacent red nodes along any path.

Every path from the root to a leaf has the same number of
black nodes. This number is called the black height of the
tree.
*)
type color = Red | Black

let pp_color color = 
  match color with 
  | Red -> "Red"
  | Black -> "Black"

type 'a tree = Leaf | Node of (color * 'a tree * 'a * 'a tree) 

let rec pp_tree tree = 
  match tree with 
  | Leaf -> "Leaf"
  | Node(color, left, value, right) -> 
      Format.sprintf("Node(%s, %d, %s, %s)") (pp_color color) value (pp_tree left) (pp_tree right)
      
(*
time O(log n)
space O(log n)
*)
let rec mem value tree = 
  match tree with 
  | Leaf -> false 
  | Node(_color, left, value', right) ->
    if value < value' then 
      mem value left 
    else if value > value' then 
      mem value right 
    else 
      true

let balance color left value right = 
  match (color, left, value, right) with 
  | (Black, Node (Red, Node (Red, a, x, b), y, c), z, d)
  | (Black, Node (Red, a, x, Node (Red, b, y, c)), z, d)
  | (Black, a, x, Node (Red, Node (Red, b, y, c), z, d))
  | (Black, a, x, Node (Red, b, y, Node (Red, c , z, d))) ->
    Node (Red, Node (Black, a, x, b), y, Node (Black, c, z, d))
  | (color, left, value, right) -> Node (color, left, value, right)


let rec insert_impl value tree = 
  match tree with 
  | Leaf -> Node(Red, Leaf, value, Leaf)
  | Node(color, left, value', right) as node ->
    if value < value' then 
      balance color (insert_impl value left) value' right
    else if value > value' then 
      balance color left value' (insert_impl value right)
    else 
      node

(* Okasaki's algorithm *)
let insert value tree = 
  let root = 
    insert_impl value tree
  in 
    match root with 
    | Leaf -> failwith "impossible"
    | Node(_, left, value, right) -> Node(Black, left, value, right)

let _ =
  let tree =
    Leaf 
    |> insert 2
    |> insert 1
    |> insert 3
  in 
    mem 2 tree |> string_of_bool |> print_endline; (* true *)
    mem 0 tree |> string_of_bool |> print_endline; (* false *)
    tree |> pp_tree |> print_endline; (* Node(2, Node(1, Leaf, Leaf), Node(3, Leaf, Leaf)) *)