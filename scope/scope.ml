let _ =
  (*
    let bindings are in effect only in the block of code
    in which they occur. For example:
  *)
  let x = 42 in
    (* y is not meaningful here *)
    x + (let y = "3110" in 
          (* *y is meaningful here *)
           int_of_string y);
  (*
    The scope of a variable is where its name is meaningful.
    Variable y is in scope only inside of the let
    expression that binds it above.

    It's possible to have overlapping bindings of the same name.
    For example:
  *)
  let x = 5 in 
    ((let x = 6 in x) + x);
  (* 
    x evaluates to 11 because of how substituion works:
    let x = 5 in
      ((let x = 6 in 6) + 5)

    The answer of why this happens is something we'll call
    the Principle of Name Irrelevance: the name of a variable
    shouldn't intrinsically matter.
    In math for example, the following two functions are the same:
    f(x) = x^2
    f(y) = y^2

    It doesn't instrinsically matter wether we call the argument
    to the function x or y; either way, it's still the squaring 
    function. Therefore, in programs, these two functions
    should be identical:

    let f x = x * x
    let f y = y * y

    This principle is more commonly known as alpha equivalence:
    the two functions are equivalent up to renaming of variable,
    which is also called alpha conversion for historical reasons.

    A new binding of a variable shadows any old binding of the
    variable name which is not the same mutability.

    Every let definition in the toplevel is effectively a nested let
    expression. So this:
    let x = 42
    let x = 22

    is effectively:

    let x = 42 in
      let x = 22 in
        ...

    The second let just binds an entirely new variable that 
    just happens to have the same as t he first let.

    Summary:
    Each let definition binds an entirely new variable.
    If that new variable happens to have the same name
    as an old variable, the new variable
    temporarily shadows the old one. But the old variable
    is still around, and its value is immutable.
  *)