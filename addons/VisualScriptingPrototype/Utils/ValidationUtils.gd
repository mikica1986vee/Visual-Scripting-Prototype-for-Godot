
static func get_valid_path_with_property(caller, node_path, property):
	if caller.get_parent() == null:
		return node_path #deserialization
	if node_path != null:
		var node = caller.get_node(node_path)
		if node != null and property in node:
			return node_path
			
	return null
	
static func get_valid_path_with_properties(caller, node_path, properties):
	if caller.get_parent() == null:
		return node_path #deserialization
	if node_path != null:
		var node = caller.get_node(node_path)
		
		for p in properties:
			if not p in node:
				return null
		
		return node_path
	
	return null

static func get_valid_path_with_method(caller, node_path, method_name):
	if caller.get_parent() == null:
		return node_path #deserialization
	if node_path != null:
		var node = caller.get_node(node_path)
		if node != null and node.has_method(method_name):
			return node_path
	
	return null
	
static func get_valid_path_with_methods(caller, node_path, method_names):
	if caller.get_parent() == null:
		return node_path #deserialization
		
	if node_path != null:
		var node = caller.get_node(node_path)
		
		for m in method_names:
			if not node.has_method(m):
				return null
		
		return node_path
	
	return null
	
static func get_valid_path_with_class(caller, node_path, class_name):
	if caller.get_parent() == null:
		return node_path #deserialization
	if node_path != null:
		var node = caller.get_node(node_path)
		if node != null and node extends class_name:
			return node_path
			
	return null