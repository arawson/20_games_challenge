extends Node

# TODO rename to safe_delete and make it truly safe
func delete(node: Node):
	if (node.is_inside_tree()):
		node.get_parent().remove_child(node)
	node.queue_free()
	print("delete object %s" % node)
	pass

func disconnect_incoming_connections(target: Object):
	for connection in target.get_incoming_connections():
		connection.source.disconnect(connection.signal_name, target, connection.method_name)

func disconnect_incoming_connections_from(target: Object, source: Object):
	for connection in target.get_incoming_connections():
		if connection.source != source:
			continue
		connection.source.disconnect(connection.signal_name, target, connection.method_name)

func disconnect_incoming_connections_for(target: Object, method_name: String):
	for connection in target.get_incoming_connections():
		if connection.method_name != method_name:
			continue
		connection.source.disconnect(connection.signal_name, target, connection.method_name)