(*
A binary search tree is a binary tree with the following 
representation invariant:

For any node n, every node in the left subtree of n has a 
value less than n's value, and every node in the right
subtree of n has a value greater than n's value.
*)
type 'a tree = Node of 'a * 'a tree * 'a tree | Leaf

(* 
time O(n) 
space O(n)
*)
let rec mem value tree = 
  match tree with 
  | Leaf -> false 
  | Node(value', left, right) ->
    if value < value' then  
      mem value left
    else if value > value' then 
      mem value right 
    else 
      true

(* 
time O(n) 
space O(n)
*)
let rec insert value tree = 
  match tree with 
  | Leaf -> Node(value, Leaf, Leaf) 
  | Node(value', left, right) as node ->
    if value < value' then 
      Node(value', insert value left, right)
    else if value > value' then 
      Node(value', left, insert value right)
    else
      node 

let rec pp_tree tree = 
  match tree with 
  | Leaf -> "Leaf"
  | Node(value, left, right) -> Format.sprintf("Node(%d, %s, %s)") value (pp_tree left) (pp_tree right)

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