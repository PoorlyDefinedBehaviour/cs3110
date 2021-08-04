(*
Arrays offer constant time performance, but come with severe
restrictions on keys. 

Association lists don't place those restrictions on keys, but
they also don't offer constant time performance.

Hashtables have both of these features.

The key ideia is that we assume the existence of a hash function
hash: 'a -> int that can convert any key to a non-negative integer.
Then we can use that function to index into an array. Of course,
we want the hash function itself to run in constant time.

Collisions

There are two well-known strategies for dealing with collisions.

One is to store multiple bindings at each array index. 
The array elements are called buckets. Typically, the bucket
is implemented as a linked list. 
To check whether an element is in the hash table, the key
is first hashed to find the correct bucket to look in. 
Then, the linked list is scanned to see if the desired element
is present. If the linked list is short, this scan is very quick.
An element is added or removed by hashing it to find the correct bucket,
then the bucket is checked to see if the elements is there,
and finally the element is added or removed appropriately
from the bucket in the usual way for linked lists.

The other strategy is to store bindings at places other than
their proper location according to the hash. When adding
a new binding to the thash table would create a collision,
the insert operation instead finds an empty location in the
array to put the binding. This strategy is known as probing,
open addressing, and closed hashing. 
A simple way to find an empty location is to search ahead
through the array indices with a fixed stride(often 1), 
looking for an unused entry; this linear probing strategy tends to 
produce a lot of clustering of elements in the table,
leading to bad performance. A better strategy is to a use a second
hash function to compute the probing interval; this strategy is called
double hashing.

Chaining is usually preferred over probing in software implementations,
because it's easier to implement the linked lists in software.
Hardware implementations have often used probing, when the size of
the table is fixed by circuitry.
*)
module type HashTable = sig
  type ('k, 'v) t

  val insert: 'k -> 'v -> ('k, 'v) t -> unit 

  val find: 'k -> ('k, 'v) t -> 'v option

  val remove: 'k -> ('k, 'v) t -> unit

  val create: ('k -> int) -> int -> ('k, 'v) t
end

module HashTable: HashTable = struct 
  type ('k, 'v) t = {
    hash: 'k -> int;
    mutable size: int;
    mutable buckets: ('k * 'v) list array
  }

  let capacity = Array.length buckets

  let load_factor table = float_of_int table.size /. float_of_int (capacity table)

  let create hash capacity = {
    hash; 
    size = 0; 
    buckets = Array.make capacity [];
  }

  let index key table = table.hash key mod capacity table

  let resize_if_needed table = 
    let lf = load_factor table in 

    if lf > 2.0 then 
      rehash table (capacity table * 2)
    else if lf < 0.5 then 
      rehash table (capacity table / 2)
    else ()

  let rehash table new_capacity = 
    let old_buckets = table.buckets in 

    table.buckets <- Array.make new_capacity [];
    table.size <- 0;

    let rehash_bucket bucket = 
      Array.iter (fun key value -> insert_no_resize key value table) bucket in

    Array.iter rehash_bucket old_buckets;

  let insert_no_resize key value table = 
    let b = index key table in 
    let old_bucket = table.buckets.(b) in 
    table.buckets.(b) <- (key, value) :: List.remove_assoc key old_bucket;
    if not (List.mem_assoc key old_bucket) then 
      table.size <- table.size + 1;
    ()

  let insert key value table = 
    insert_no_resize key value table;
    resize_if_needed table;

  let find key table = List.assoc_opt key table.buckets.(index key table)

  let remove_no_resize key table = 
    let b = index key table in 
    let old_bucket = table.buckets.(b) in
    table.buckets.(b) <- List.remove_assoc key table.buckets.(b);
    if List.mem_assoc key old_bucket then 
      table.size <- table.size - 1;
    ()

  let remove key table = 
    remove_no_resize key table;
    resize_if_needed table;
end

let _ =
  print_endline "Hello worlld";