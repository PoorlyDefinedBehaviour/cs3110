module type Stack = sig 
  type 'a t 

  val empty: unit -> 'a t 

  val push: 'a -> 'a t -> 'a t

  val peek: 'a t -> 'a option 

  val pop: 'a t -> 'a t
end

module type MutableStack = sig 
  type 'a t

  val empty: 'a t

  val push: 'a -> 'a t -> unit

  val peek: 'a t -> 'a option

  val pop: 'a t -> unit
end

module MutableRecordStack = struct 
  type 'a node = {
    value: 'a;
    mutable next: 'a node option;
  }

  type 'a t = {
    mutable top: 'a node option
  }

  let empty () = {top = None}

  let push x stack = 
    stack.top <- Some {value = x; next = stack.top}

  let peek stack = 
    match stack.top with 
    | None -> None 
    | Some {value; _} -> Some value
    
  let pop stack = 
    match stack.top with 
    | None -> stack.top <- None
    | Some {next; _} -> stack.top <- next
end

let string_of_opt opt = 
  match opt with 
  | None -> "None"
  | Some value -> Format.sprintf "Some(%d)" value

let _ =
  let stack = MutableRecordStack.empty() in 
  MutableRecordStack.push 1 stack;
  MutableRecordStack.push 2 stack;
  MutableRecordStack.push 3 stack;

  print_endline (string_of_opt (MutableRecordStack.peek stack)); (* Some(3) *)

  MutableRecordStack.pop stack;

  print_endline (string_of_opt (MutableRecordStack.peek stack)); (* Some(2) *)

  MutableRecordStack.pop stack;

  print_endline (string_of_opt (MutableRecordStack.peek stack)); (* Some(1) *)