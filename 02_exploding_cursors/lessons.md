
# Lessons Learned

## Don't access tree during setter in initialization
 - https://www.reddit.com/r/godot/comments/s4ptf0/when_are_setters_called_during_tree_loading/
 
 > Setters are called as part of initialization, directly after _init.

 > Setters for EXPORTED properties are then called AGAIN, directly after _ready. (This is how the editor is capable of setting properties for nodes, as an example.)

 > Correct practice is to not access the tree in a setter, at all. But sometimes emitting a signal or making a deferred call can be used when doing otherwise would be too much work.

 ## The command pattern is really nice
 The huge advantage of using the command pattern is that you don't have to redo all of your functions and signals if you need to add a new parameter.
