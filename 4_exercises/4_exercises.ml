
(*
Used to evaluate an expression to the right of the operator,
before using it in other expression.
*)
let ($) f x = f x

let square x = x * x

let repeat n f x = 
  let rec loop i acc =
    if i < n then 
      loop (i + 1) (f acc);
  in 
    loop 0 x

(*
Use fold_left to write a function product_left that
computes the product of a list of floats.
The product of the empty list is 1.0.
*)
let product_left = List.fold_left ( *. ) 1.0

(*
Use fold_right to write a function product_right that
computes the product of a list of floats.
*)
let product_right xs = List.fold_right ( *. ) xs 1.0

(*
Given the following function clip, 
write a function cliplist that clips every integer in
its input list.
*)
let clip n = 
  if n < 0 then 0 
  else if n > 10 then 10
  else n

let cliplist = List.map clip

let pp_list xs = 
  let elements = xs 
    |> List.map string_of_int
    |> String.concat "; "
  in 
    "[" ^ elements ^ "]"

(*
Write a function sum_cube_odd n that computes
the sum of the cubes of all the odd numbers
between 0 and n inclusive. 
Do not write any new recursive functions. 
*)
let rec pow exponent = function 
  | 0 -> 1
  | 1 -> exponent 
  | n when n < 0 -> failwith "input must be greater than or equal to 0"
  | n ->  
    let y = pow exponent (n /2) in 
    y * y * (if n mod 2 = 0 then 1 else exponent)

let sum_cube_odd n = 
  List.init n succ 
  |> List.filter (fun x -> x mod 2 != 0)
  |> List.map (fun x -> pow x 3)
  |> List.fold_left (+) 0

(*
Consider writing a function 
exists: ('a -> bool) -> 'a list -> bool,
such that exists p [a1; ...; an] returns whether 
at least one element of the list satisfies the predicate p.
That is, it evaluates the same as (p a1) || (p a2) || ... || (p an). 
When applied to an empty list, it evaluates to false.
*)
let rec exists_rec predicate xs = 
  match xs with 
  | [] -> false
  | head :: tail -> 
    if predicate head then 
      true 
    else 
      exists_rec predicate tail

let exists_fold predicate xs = List.fold_left (fun found x -> found || predicate(x)) false xs 

let exists_lib = List.exists

(*
Write a function uncurry that takes in a curried function 
and returns the uncurried version of that function. 
Remember that curried functions have types like 'a -> 'b -> 'c,
and the corresponding uncurried function will have the type
'a * 'b -> 'c.
Therefore uncurry should have the folowing type:

val uncurry : ('a -> 'b -> 'c) -> 'a * 'b -> 'c
*)
let uncurry f = fun (x, y) -> f x y

let uncurried_nth = uncurry List.nth

(*
Write the inverse function curry.
It should have the following type:

val curry : ('a * 'b -> 'c) -> 'a -> 'b -> 'c
*)
let curry f x y = f (x, y)

(*
Using the following defintion of tree:

type 'a tree = 
| Leaf 
| Node of 'a * 'a tree * 'a tree

Write a function tree_map : ('a -> 'b) -> 'a tree -> 'b tree
that applies a function to every node of a tree,
just like List.map applies a function to every element of a list.
*)
type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree

let rec tree_map f tree = 
  match tree with 
  | Leaf -> Leaf
  | Node (value, left, right) -> Node(f(value), tree_map f left, tree_map f right)

let rec pp_tree tree =
  match tree with 
  | Leaf -> "Leaf"
  | Node (value, left, right) -> Format.sprintf "Node(%d, %s, %s)" value (pp_tree left) (pp_tree right)
  
(*
Use your tree_map function to implement a function 
add1 : int tree -> int tree that 
increments every node in an int tree.
*)
let tree_add_1 = tree_map (fun x -> x + 1)

let _ = 
  (* $ makes 2 + 2 be evaluated before applying square to its result *)
  square $ 2 + 2 |> string_of_int |> print_endline; (* 16 *)

  repeat 2 
    (fun message -> 
      print_endline message; 
      message
    ) 
    "hello world";

  product_left [1.0; 2.0; 3.0; 4.0; 5.0] |> string_of_float |> print_endline;
  product_right [1.0; 2.0; 3.0; 4.0; 5.0] |> string_of_float |> print_endline;

  cliplist [-10; 2; 3; 4; 5; 30] |> pp_list |> print_endline;

  sum_cube_odd 5 |> string_of_int |> print_endline;

  exists_rec (fun x -> x = 2) [1; 2; 3; 4; 5] |> string_of_bool |> print_endline;
  exists_rec (fun x -> x = 10) [1; 2; 3; 4; 5] |> string_of_bool |> print_endline;

  exists_fold (fun x -> x = 2) [1; 2; 3; 4; 5] |> string_of_bool |> print_endline;
  exists_fold (fun x -> x = 10) [1; 2; 3; 4; 5] |> string_of_bool |> print_endline;

  exists_lib (fun x -> x = 2) [1; 2; 3; 4; 5] |> string_of_bool |> print_endline;
  exists_lib (fun x -> x = 10) [1; 2; 3; 4; 5] |> string_of_bool |> print_endline;

  uncurried_nth ([1; 2; 3], 2) |> string_of_int |> print_endline;
  (curry uncurried_nth) [1; 2; 3] 2 |> string_of_int |> print_endline;

  let t = 
    Node(
      1,
      Node(2, Leaf, Leaf),
      Node(3, Leaf, Leaf)
    )
  in 
    tree_map (fun x -> x + 1) t |> pp_tree |> print_endline;
    tree_add_1 t |> pp_tree |> print_endline;