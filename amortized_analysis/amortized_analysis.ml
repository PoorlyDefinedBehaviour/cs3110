(*
Amortization is a financial term. One of its meaning is to pay
off a debt over time. In algorithmic analysis, we use it to refer
to paying off the cost of an expensive operation by inflating
the cost of inexpensive operations. In effect, we pre-pay
the cost of a later expensive operation by adding some
additional cost to earlier cheap operations.

The amortized complexity or amortized running time of a sequence
of operations that each have cost T1, T2, ..., Tn, is
just the average cost of each operation:

(T1 + T2 + ... + Tn) / n

Thus, even if one operation is specially expensive, we could average
that out over a bunch of inexpensive operations.

Applying that ideia to a hash table, suppose thte table has 8
bindings and 8 buckets. Then 8 more inserts are made. 
The first 7 are (expected) constant-time, but the 8th insert 
is linear time: it increases the load factor to 2, causing a resize,
thus causing rehashing of all 16 bindings into a new table.
The total cost over that series of operations is therefore 
the cost 8 + 16 inserts. For simplicity of calculation, we could
groslly wound that up to 16 + 16 = 32 inserts. So the average
cost of each operation in the sequence is 32/8 = 4 inserts.

In other words, if we just pretended each insert cost four times
its normal price, the final operation in the sequence would
have been pre-paid by the extra price we paid for earlier inserts.
And all of them would be constant-time, since four times a constant
is still a constant.
*)

let _ = print_endline "hello world";