
extends "BaseEffect.gd"

const MIN_POSITIVE_FLOAT_VAL = 1.175494351e-38

export(PackedScene) var target
export(NodePath) var parent_path
export(NodePath) var use_as_position_path
export(Vector2) var pos_offset = Vector2(0, 0)
export(float) var rot_degree_offset = 0.0 #setget _validate_rot_degree_offset
export(Vector2) var scale_multiplier = Vector2(1, 1) setget _validate_scale_multiplier
	
func add_on_start_effect(): 
	_instance_target()
	pass
	
func _do_fast_forward():
	_instance_target()
	pass
	
func _instance_target():
	var instance = null
	if target != null:
		instance = target.instance()
		
	if instance == null:
		return
	
	var l_parent = null
	if parent_path != null and parent_path != "":
		l_parent = get_node(parent_path)
		
	if l_parent == null:
		l_parent = get_owner()
		
	var l_position_to = null
	if use_as_position_path != null and use_as_position_path != "":
		l_position_to = get_node(use_as_position_path)
		
	if l_position_to == null:
		l_position_to = l_parent
		
	if l_position_to == null:
		instance.queue_free()
		return
		
	var gt = l_position_to.get_global_transform()
	l_parent.add_child(instance)
	gt = gt.translated(pos_offset).rotated(deg2rad(rot_degree_offset)).scaled(scale_multiplier)
	instance.set_global_transform(gt)
	pass
	
func _validate_rot_degree_offset(vec3):
	#ignored for now
	pass
	
func _validate_scale_multiplier(vec3):
	if vec3.x == 0.0:
		vec3.x = MIN_POSITIVE_FLOAT_VAL
	
	if vec3.y == 0.0:
		vec3.y = MIN_POSITIVE_FLOAT_VAL
	
	#if vec3.z == 0.0:
	#	vec3.z = MIN_POSITIVE_FLOAT_VAL
	
	scale_multiplier = vec3
	pass