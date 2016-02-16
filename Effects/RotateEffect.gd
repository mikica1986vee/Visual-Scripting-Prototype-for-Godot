tool
extends 'BaseEffect.gd'

export(NodePath) var target_path setget _validate_target

export var duration = 1.0
export var curve = 1.0

export var curve_is_for_delta = false

#export(int, 'local', 'global') var rot_type = 0
export(int, 'local') var rot_type = 0
export(int, 'to', 'by') var move_type = 0
#export var forward = false

export var rotate_deg = 0.0

var _target = null
var _duration_timer = 0.0
var _starting_rotation = 0.0

var _old_rotation = 0.0

func add_on_start_effect():
	if target_path == null:
		return
		
	_target = get_node(target_path)
	_duration_timer = 0.0
	
	_starting_rotation = _get_rot_type_rot()
	_old_rotation = 0.0
	
	enable_effect()
	pass
	
func add_on_process_effect(dt):
	if _target == null: #think about this
		return
		
	_duration_timer += dt
	
	var norm_de = _duration_timer
	
	if duration <= 0.0:
		norm_de = 1.0
	else:
		norm_de /= duration
	
	if norm_de > 1.0:
		norm_de = 1.0
	
	_do_rotation(dt, norm_de)
	
	if _duration_timer > duration:
		effect_is_done()
	pass
	
func _do_rotation(dt, normalized):
	var easing = _get_easing(normalized)
	var new_rot = _calculate_new_rot(easing)
	_set_rot_type_rot(new_rot)
	pass
	
func _get_rot_type_rot():
	if rot_type == 0: #local
		return _target.get_rot()
	else: #global
		return _target.get_global_transform().get_rotation()
	pass
		
func _set_rot_type_rot(new_rot):
	if rot_type == 0: #local
		return _target.set_rot(new_rot)
	else: #global
		var m = _target.get_global_transform()
		_target.set_global_transform(m.rotated(new_rot))
	pass
	
func _get_easing(norm):
	return ease(norm, curve)
	
func _calculate_new_rot(easing):
	var val
	var rotate_rad = deg2rad(rotate_deg)
	if move_type == 0: #to
		if curve_is_for_delta:
			var rot = _get_rot_type_rot()
			var delta = (rotate_rad - rot)
			delta *= easing
			val = rot + delta
			#print ('rotate to curving delta, val: ', val, ' start: ', _starting_rotation)
		else:
			var delta = rotate_rad - _starting_rotation
			delta *= easing
			val = _starting_rotation + delta
			#print ('rotate to, val: ', val)
	else: #by
		if curve_is_for_delta:
			var delta = rotate_rad - _old_rotation
			delta *= easing
			val = _old_rotation + delta
			_old_rotation = val
			#print ('rotate by curving delta, val: ', val)
		else:
			var delta = rotate_rad
			delta *= easing
			val = delta + _starting_rotation
			#print ('rotate by, val: ', val)
			
	#print ('move type: ', move_type)
	return val
	
func _do_fast_forward():
	if target_path == null:
		return
	
	if _target == null:
		_target = get_node(target_path)
	
	add_on_process_effect(duration)
	pass
	
#validation
func _validate_target(path):
	target_path = get_valid_path_with_methods(path, ['get_rot', 'set_rot', 'get_global_transform', 'set_global_transform'])
