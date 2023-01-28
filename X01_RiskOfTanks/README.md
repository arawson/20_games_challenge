
# Design
What does this game accomplish? It's just an overhead Risk of Rain?!?!?
Well, Mister Debbie Downer, I don't know Godot yet, and I can't well make a game if I don't know the engine I'm going to be working with, now can I?
The entire point of this project is to get a feel for working with Godot.

## Proccing
TODO

## Items
### Needs
 1. A "drop" object which is the interactable portion.
 2. An inventory manager to control the proc pool and the procables on it correctly with respect to their items.

### Changes to Existing Structure
 1. Create an "Item" directory.
 2. Move all of "Dynamo" into its own directory in the item directory. Trying to keep things organized.

### New Nodes:

#### `Item`
 * It extends Node2D.
 * It has a method to get a UI icon.
 * It has a method which gets the name of the procable it represents.
 * A pickup method tells it when it has been acquired and can remove itself from the world.

#### `ProcManager`
 1. Extends Node
 2. Manages a ProcPool
 3. Receives signals about item acquisition

#### `ProcMapping`
 1. Globally loaded.
 2. Extends Node
 3. Maintains the mapping between Procable names and items.

### Changes to Existing Nodes:

#### `Procable`
  1. New methods to increment and decrement stacks.
  2. New method to get official name.

#### `ProcPool`
 1. New getter for procables by name.

## Player Abilities

### Needs
 1. Some ideas as to what the player can do beyond shooting the gun.
 2. Tracking of cooldowns and charges, ideally in a way that can be universal even beyond player controlled entities.
 3. A UI to display the abilities.
