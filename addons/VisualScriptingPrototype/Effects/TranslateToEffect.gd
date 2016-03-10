tool
extends "BaseEffect.gd"

export(NodePath) var target_path setget _validate_target

export var duration = 1.0
export var curve = 1.0

export var curve_is_for_delta = false

export var use_per_axis_curve = false
export var per_axis_curve = Vector2(1, 1)

export(int, 'local', 'global') var pos_type = 0
export(int, 'to', 'by') var move_type = 0
export var forward = false

export var translate_to = Vector2()

var _target = null
var _duration_timer = 0.0
var _starting_position = Vector2()

var _old_translated_by = Vector2()

func add_on_start_effect():
	if target_path == null:
		return
		
	_target = get_node(target_path)
	_duration_timer = 0.0
	
	_starting_position = _get_pos_type_pos()
	_old_translated_by = Vector2()
	
	if _target:
		enable_effect()
	pass
	
func add_on_process_effect(dt):
	_duration_timer += dt
	
	var norm_de = _duration_timer
	
	if duration <= 0.0:
		norm_de = 1.0
	else:
		norm_de /= duration
	
	if norm_de > 1.0:
		norm_de = 1.0
	
	_do_translation(dt, norm_de)
	
	if _duration_timer > duration:
		effect_is_done()
	pass
	
func _do_translation(dt, normalized):
	var easing = _get_easing(normalized)
	var new_pos = _calculate_new_pos(easing)
	_set_pos_type_pos(new_pos)
	pass
	
func _get_pos_type_pos():
	if pos_type == 0: #local
		return _target.get_pos()
	else: #global
		return _target.get_global_pos()
	pass
		
func _set_pos_type_pos(new_pos):
	if pos_type == 0: #local
		return _target.set_pos(new_pos)
	else: #global
		_target.set_global_pos(new_pos)
	pass
	
func _get_easing(norm):
	if use_per_axis_curve:
		return Vector2(ease(norm, per_axis_curve.x), ease(norm, per_axis_curve.y))
	else:
		var easing = ease(norm, curve)
		return Vector2(easing, easing)
	pass
	
func _calculate_new_pos(easing):
	var val
	if move_type == 0: #to
		if curve_is_for_delta:
			var pos = _get_pos_type_pos()
			var delta = (translate_to - pos)
			delta.x *= easing.x
			delta.y *= easing.y
			val = pos + delta
			#print ('move to curving delta, val: ', val, ' start: ', _starting_position)
		else:
			var delta = translate_to - _starting_position
			delta.x *= easing.x
			delta.y *= easing.y
			val = _starting_position + delta
			#print ('move to, val: ', val)
	else: #by
		if curve_is_for_delta:
			var adj_translate
			
			if forward:
				adj_translate = translate_to.rotated(_target.get_rot())
			else:
				adj_translate = translate_to
			
			var delta = adj_translate - _old_translated_by
			
			if forward:
				var tr = _target.get_rot()
				delta = delta.rotated(-tr)
				delta.x *= easing.x
				delta.y *= easing.y
				delta = delta.rotated(tr)
			else:
				delta.x *= easing.x
				delta.y *= easing.y
			
			val = _old_translated_by + delta
			_old_translated_by = val
			val += _starting_position
			#print ('move by curving delta, val: ', val)
		else:
			var delta = translate_to
			delta.x *= easing.x
			delta.y *= easing.y
			
			if forward:
				delta = delta.rotated(_target.get_rot())
			
			val = delta + _starting_position
			#print ('move by, val: ', val)
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
	target_path = get_valid_path_with_methods(path, ['get_pos', 'set_pos', 'get_global_pos', 'set_global_pos'])
