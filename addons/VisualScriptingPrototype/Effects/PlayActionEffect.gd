tool
extends "BaseEffect.gd"

export(NodePath) var target_path setget _validate_target

var _target = null

func add_on_start_effect():
	if target_path == null:
		return
		
	_target = get_node(target_path)
	
	if _target.is_action_playable():
		enable_effect()
		_target.play_action_with_callback(self, 'effect_is_done')
	
	pass
	
func _do_fast_forward():
	if target_path != null:
		_target = get_node(target_path)
		_target.play_action()
		_target.fast_forward()
	pass

#validation
func _validate_target(path):
	target_path = get_valid_path_with_methods(path, ['play_action', 'is_action_playable'])
