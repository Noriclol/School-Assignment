extends Node

func instance_node_at_location(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance


func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instantiate()
	parent.add_child(node_instance, true)
	return node_instance