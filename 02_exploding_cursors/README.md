# Exploding cursors
Use the innate power of cursors to secure your computer!
# Design
 1. The game is played on a square grid.
 2. Units take up squares on the grid.
## Turn Concepts
 1. A turn is over when a faction confirms it is over.
	 1. A faction may end a turn early.
 2. A unit can use abilities, move, and/or attack.
	 1. Most units end their actions with an ability or attack.
## Assets
### Dimensions
### Color Scheme
White icons on colored blocks for different factions.
## Turn-Based
### Turn-Manager
Global object holding the details of the active factions and the turn order.
 1. Stores the faction ID of the currently active faction.
 2. Is notified when a faction ends its turn.
 3. Notifies the next faction in the turn order that they can go.
### Faction
Stores the ID of a faction. Holds the units under it in the tree. Manages faction-wide events like ending a turn.
A faction must respond to these events:
 1. A unit taking damage.
 2. A unit being lost.
 3. A new unit being spawned.
### Faction-Registry
Stores lookup of the faction IDs and makes sure a faction isn't loaded twice.
### Unit
A unit has these things conceptually:
 1. A set of blocks that represents its hit points.
 2. A maximum size.
 3. A movement speed for how many blocks it can traverse in a round.
 4. A special ability.
 5. An attack damage.
A unit must track these things:
 1. The blocks which are part of its body.
 2. Which faction it belongs to.
 3. How many moves or actions it has left this turn.
A unit must respond to these events:
 1. Taking damage.
