(*
The big difference between variants and tuples/records is
that a value of variant type is one of a set of possibilites,
whereas a value of a tuple/record type provides
each of a set of possibilities. Going back to our examples,
a value of type day is one of Sunday or Monday or etc. 
But a value of type pokemon provides each of a string
and int.

One-of types are more commonly known as sum types,
and each-of types as product types. 
Those names come from set theory. 
Variants are like disjoint union,
because each value of a variant comes from one of many underlying
sets(and thus far each of those sets is just a singel constructor
hence has cardinality one).
And disjoint union is sometimes written with a
summation operator Σ.
Tuples/records are like cartesian product(bartosz lectures vibes),
because each value of a tuple/record contains a value from each
of many underlying sets. And cartsian product is usually written
with a product operator ×.
*)
let _ = 