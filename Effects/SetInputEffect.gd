tool
extends 'BaseEffect.gd'

export(NodePath) var target_path setget _validate_path

export(int, 'false', 'true') var set_input_to = 1

var _target = null

func add_on_start_effect():
	_do_fast_forward()
	
func _do_fast_forward():
	if target_path == null:
		return
		
	_target = get_node(target_path)
	
	if _target:
		var set_to_bool = true
		
		if set_input_to == 0:
			set_to_bool = false
		
		if _target.has_method('set_takes_input'):
			_target.set_takes_input(set_to_bool)
		else:
			_target.takes_input = set_to_bool

func _validate_path(path):
	target_path = get_valid_path_with_method(path, 'set_takes_input')
	if target_path == null:
		target_path = get_valid_path_with_property(path, 'takes_input')