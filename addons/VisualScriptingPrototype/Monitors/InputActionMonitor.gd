tool
extends "BaseMonitor.gd"

const ValidationUtils = preload("../Utils/ValidationUtils.gd")

export var action_name = "" setget _validate_action_name
export(NodePath) var on_action_down_path setget _validate_action_down
export(NodePath) var on_action_up_path setget _validate_action_up

export var fire_always = true

var _pressed = false


func add_on_enable_tracking():
	set_process(false)
	set_fixed_process(false)
	set_process_input(true)
	
	if Input.is_action_pressed(action_name):
		_pressed = true
		_fire_action(on_action_down_path)
	pass
	
func add_on_disable_tracking():
	set_process_input(false)
	if _pressed and fire_always:
		_fire_action(on_action_up_path)
	
	_pressed = false
	pass
	
func _input(ev):
	if ev.is_action(action_name):
		if _pressed:
			if not ev.pressed:
				_fire_action(on_action_up_path)
				pass
		else:
			if ev.pressed:
				_fire_action(on_action_down_path)
				pass
				
		_pressed = ev.pressed
	pass
	
func _fire_action(action_path):
	if action_path == null or action_path == "":
		return
		
	var a = get_node(action_path)
	if a != null:
		a.play_action()
		
func _validate_action_name(name):
	if InputMap.has_action(name):
		action_name = name
	else:
		print("No input action with name: ",  name)
		action_name = ""
	pass
		
func _validate_action_down(path):
	on_action_down_path = ValidationUtils.get_valid_path_with_method(self, path, "play_action")
	pass
	
func _validate_action_up(path):
	on_action_up_path = ValidationUtils.get_valid_path_with_method(self, path, "play_action")
	pass