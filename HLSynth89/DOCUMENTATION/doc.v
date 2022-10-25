
Some syntax:
 || means catenation
 |  means or
 All values are given as integers
Some semantics:
 All operations may be chained (but must not of course)
 Imperative semantics.  ";" means after (but may be ignored if data
   dependencies allow to do so). Calls to other MODULES are also
   imperative, i.e. the control is passed to the called MODULE
   and returned to the calling MODULE after completion.
 A loop takes at least 1 clock cycle per loop cycle
 WHILE conditions are tested at the beginning of a loop (loop may
   execute 0 times)
 UNTIL conditions are tested at the end of a loop(loop will always
   execute once at least).
 All arithmetic is two complements integer arithmetic.
 IF and CASE pick exactly one of the conditional branches.
 Variables retain their value until they are overwritten. Initially
   they have any value.
 OUTputs retain their value until they are overwritten, but at least
   one clock cycle. Initially they have any value.
 INputs are read when assigned. Consecutive "reads" (assignments)
   mean different values, i.e. they must happen in different cycles.

All this is OK for SYNCHRONOUS hardware. The examples are not further
constrained in time (only the semantics above constrains them somehow).
This keeps the specification simple.



