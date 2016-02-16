tool
extends "BaseEffect.gd"

export var set_state_to = true
export(NodePath) var condition_path setget _set_condition_path
var _condition
	
func add_on_start_effect(): #happens after delay
	fast_forward()
	pass
	
func _do_fast_forward(): #must be overriden in derived classes!, should finish the effect in correct way
	if _condition == null:
		_condition = get_node(condition_path)
	
	_condition.set_state(set_state_to)
	pass

func _set_condition_path(new_condition_path): #validation :)
	if get_parent() == null:
		condition_path = new_condition_path
	else:
		var node = get_node(new_condition_path)
		if node != null and ("state" in node or node.has_method("set_state")):
			condition_path = new_condition_path
		else:
			condition_path = null
	pass