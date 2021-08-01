(*
Queues and stacks are fairly similar interfaces.
*)

module type Queue = sig 
  type 'a t

  val empty: 'a t 

  val is_empty: 'a t -> bool 

  val enqueue: 'a -> 'a t -> 'a t

  (* 
  Returns an option when queue is empty
  instead of raising an exception
  *)
  val peek: 'a t -> 'a option

  val dequeue: 'a t -> 'a t 
end

module ListQueue: Queue = struct 
  type 'a t = 'a list

  (* time O(1) *)
  let empty = []

  (* time O(1)? *)
  let is_empty queue = queue = []

  (* time O(n) *)
  let enqueue x queue = queue @ [x]

  (* time O(1) *)
  let peek queue = 
  (* Could also use List.nth_opt queue 0 *)
    match queue with
    | [] -> None 
    | x :: _ -> Some x

  (* time O(1) *)
  let dequeue queue = 
    match queue with 
    | [] -> []
    | _ :: tail -> tail
end

let string_of_opt opt = 
  match opt with 
  | None -> "None"
  | Some(value) -> Format.sprintf "Some(%d)" value


(*
With two-list queues, we get a constant time enqueue operation:
just cons a new element onto back. But dequeue is not longer just
a simple match: it has to call norm to ensure the queue it returns
is in normal form.

So it might seem as though dequeue no longer has contant time
efficiency. Nonetheless, with an advanced algorithmic analysis
technique called amortized analysis, it is possible to conclude
that this implementation of dequeue is essentialy constant time.
*)
module TwoListQueue: Queue = struct 
  type 'a t = {
    front: 'a list;
    back: 'a list
  }

  let empty = {front = []; back = []}

  (* time O(1) *)
  let is_empty queue =
    match queue with 
    | {front = []; back = []} -> true
    | _ -> false

  let norm queue =
    match queue with 
    | {front = []; back} -> {front = List.rev back; back = []}
    | queue -> queue

  (* time ~O(1) *)
  let enqueue x queue = norm {queue with back = x :: queue.back}

  (* time O(1) *)
  let peek queue = 
    match queue with 
    | {front = []; _ } -> None 
    | {front = x :: _; _} -> Some x

  (* time ~O(1) *)
  let dequeue queue =
    match queue with 
    | {front = _ :: xs; back} -> norm {front = xs; back}
    | empty_queue -> empty_queue
end

let _ =
  ListQueue.empty 
  |> ListQueue.enqueue 1
  |> ListQueue.enqueue 2
  |> ListQueue.enqueue 3
  |> ListQueue.peek
  |> string_of_opt
  |> print_endline; (* Some(1) *)

  TwoListQueue.empty 
  |> TwoListQueue.enqueue 1
  |> TwoListQueue.enqueue 2
  |> TwoListQueue.enqueue 3
  |> TwoListQueue.peek
  |> string_of_opt
  |> print_endline; (* Some(1) *)