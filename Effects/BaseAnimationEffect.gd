tool
extends "BaseEffect.gd"

export(NodePath) var target_path setget _validate_target
export var animation_name = "" setget _validate_animation

var _target = null

func add_on_prepare_effect(): #happens before delay
	if target_path != null:
		_target = get_node(target_path)
	pass
	
func add_on_start_effect(): #happens after delay
	if _target != null:
		do_animation_action()
	else:
		print(get_name() + ": AnimationPlayer not set")
	pass
	
func do_animation_action():
	print("override in derived class!")
	assert(false)
	pass
	
func add_on_effect_is_done():
	pass
	
func _do_fast_forward(): #must be overriden in derived classes!, should finish the effect in correct way
	do_animation_action()
	pass

func _validate_target(path):
	target_path = get_valid_path_with_class(path, AnimationPlayer)
	pass
	
func _validate_animation(anim):
	if target_path != null and get_node(target_path) != null:
		var anims = get_node(target_path).get_animation_list()
		
		if anim in anims:
			animation_name = anim
		else:
			animation_name = ""
		pass
	else:
		animation_name = anim
	pass