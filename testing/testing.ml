(*
The goal we're after is that programs behave as we intend
them to behave. Validation is the process of building our
confidence in correct program behaviour. There are many ways
to increase that confidence. Social methods, formal methods, 
and testing are three of tem.

-- Social methods --

Involve developing programs with other people, relying on their
assistance to improve correctness. Some good techniques
include the following:

Code walkthrough

In the walkthrough approach, the programmer presents the documentation
and code to a reviewing team, and the team gives comments.
This is an informal process. The focus is on the code
rather than the coder, so hurt feelings are easier to avoid.

Code inspection

Here, the review team drives the code review process. 
Some, though not necessarily very much, team preparation beforehand
is useful. They define goals for the review process and 
interact with the coder to understand where there may be
quality problems.
Again, making the process as blameless as possible is important.

Pair programming

The most informal approach to code review is through pair programming,
in which code is developed by a pair of engineers: 
the driver who writes the code, and the observer who watches.
The role of the observer is to be a critic, to think about
potential errors, and to help navigate larger design issues.
It's usually better to have the observer be the engineer
with the greater experience with the coding task at hand.
The observer reviews the code, serving as the devil's advocate
that the driver must convince. When the pair is developing
specifications, the observer thinks about how to make
specs clearer or shorter. Pair programming has other benefits.
It is often more fun and educational to work with a partner,
and it helps focus both partners on the task.

-- Formal methods --

Uses the power of mathematics and logic to validate program behaviour.
Verification uses the program code and its specifications
to construct a proof that the program behaves correctly
on all possible inputs. There are research tools available to help
with program veritification, often based on automated
theorem provers, as well as research languages that are designed
for program verification. Verification tends to be expensive
and to require thinking carefully about and deeply understanding
the code to be verified. So in pratice, it tends to be
applied to code that is important and relatively short.
Verification is particularly valuable for criticals ystems where
testing is less effective. Because their exceution is not 
deterministic, concurrent programs are hard to test,
and sometimes subtle bugs can only be found by attempting to
verify the code formally.

-- Testing --

Involves actually executing the program on sample inputs 
to see wether the behaviour is as expected. By comparing the
actual results of the program with the expected results,
we find outwhether the program really works on the particular
inputs we try it on. Testing can never provide the absolute
guarantees that formal methods do, but it is significantly easier
and cheaper to do.
*)

let () = print_endline "Hello, World!"
