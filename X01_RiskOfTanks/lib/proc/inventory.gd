class_name Inventory
extends Node

# An inventory needs:
# 1. A dictionary of keys
# 2. Each key maps to a resource
# 3. Those resources each have a "count" to track how many of that object are there
# 4. Methods going in to add and remove items from the inventory
# 5. Signals going out to notify of inventory changed
