extends Node

# TODO rename to safe_delete and make it truly safe
func delete(node: Node):
	if (node.is_inside_tree()):
		node.get_parent().remove_child(node)
	node.queue_free()
	print("delete object %s" % node)
	pass
