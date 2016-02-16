tool
extends "BaseEffect.gd"

export(NodePath) var target_path setget _validate_target

export var duration = 0.3
export var curve = 1.0

export var curve_is_for_delta = false

export(float, 0.0, 1.0, 0.01) var fade_to_value = 0.0


var _target = null
var _duration_expired = 0.0
var _start_opacity
	
func add_on_start_effect(): #happens after delay
	if target_path == null:
		return
	_target = get_node(target_path)
	_duration_expired = 0.0
	_start_opacity = _target.get_opacity()
	
	enable_effect()
	pass
	
func add_on_process_effect(dt): #starts happening after delay, will be called AT LEAST once
	_duration_expired += dt
	
	var norm_de = _duration_expired
	
	if duration <= 0.0:
		norm_de = 1.0
	else:
		norm_de /= duration
	
	if norm_de > 1.0:
		norm_de = 1.0
	
	var easing = ease(norm_de, curve)
	
	var val
	
	if curve_is_for_delta:
		var current_opacity = _target.get_opacity()
		var delta = (fade_to_value - current_opacity) * easing
		val = current_opacity + delta
	else:
		val = _start_opacity + (fade_to_value - _start_opacity) * easing
	
				
	_target.set_opacity(val)
	
	if _duration_expired > duration:
		effect_is_done() #must be called!
	pass
	
func _do_fast_forward(): #must be overriden in derived classes!, should finish the effect in correct way
	print (get_name() + " _do_fast_forward()")
	if _target == null:
		_target = get_node(target_path)
	
	_target.set_opacity(fade_to_value)
	
	pass
	
#validation

func _validate_target(path):
	target_path = get_valid_path_with_method(path, "set_opacity")
	if target_path != null:
		target_path = get_valid_path_with_method(path, "get_opacity")
