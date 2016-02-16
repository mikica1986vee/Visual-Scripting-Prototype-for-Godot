tool
extends CollisionObject2D

export(NodePath) var on_mouse_enter setget _on_mouse_enter_validation
export(NodePath) var on_mouse_exit setget _on_mouse_exit_validation
export(NodePath) var on_mouse_down setget _on_mouse_down_validation
export(NodePath) var on_mouse_up setget _on_mouse_up_validation
export(NodePath) var on_mouse_click setget _on_mouse_click_validation

export var takes_input = true setget set_takes_input

export var click_excludes_up = false

var _mouse_is_down = false

func _ready():
	if get_tree().is_editor_hint():
		return
	connect("mouse_enter", self, "_mouse_entered")
	connect("mouse_exit", self, "_mouse_exited")
	
	set_takes_input(takes_input)
	pass
	
func set_takes_input(set):
	if set == takes_input:
		return
		
	takes_input = set
	#set_process_unhandled_input(set) #this is now done in _mouse_enter and _mouse_exit
	set_pickable(set)
	
func _unhandled_input(event):
	if event.type == InputEvent.MOUSE_BUTTON and event.button_index == 1:
		if event.pressed:
			if not _mouse_is_down:
				_mouse_down()
		else:
			if click_excludes_up:
				if _mouse_is_down:
					_mouse_click()
				else:
					_mouse_up()
			else:
				var fire_click = _mouse_is_down
				_mouse_up()
				if fire_click:
					_mouse_click()
	pass
	
func _mouse_down():
	_mouse_is_down = true
	_play_action_from_path(on_mouse_down)
	pass
	
func _mouse_up():
	if not _mouse_is_down:
		return #fires on _mouse_up on pointer exit
	_mouse_is_down = false
	_play_action_from_path(on_mouse_up)
	pass
	
func _mouse_click():
	_mouse_is_down = false
	_play_action_from_path(on_mouse_click)
	pass

func _mouse_entered():
	set_process_unhandled_input(true)
	_play_action_from_path(on_mouse_enter)
	pass
	
func _mouse_exited():
	set_process_unhandled_input(false)
	if _mouse_is_down:
		_mouse_up()
	_mouse_is_down = false
	_play_action_from_path(on_mouse_exit)
	pass

func _on_mouse_enter_validation(node_path):
	on_mouse_enter = _validate_get_proper(node_path)
	pass
	
func _on_mouse_exit_validation(node_path):
	on_mouse_exit = _validate_get_proper(node_path)
	pass
	
func _on_mouse_down_validation(node_path):
	on_mouse_down = _validate_get_proper(node_path)
	pass
	
func _on_mouse_up_validation(node_path):
	on_mouse_up = _validate_get_proper(node_path)
	pass
	
func _on_mouse_click_validation(node_path):
	on_mouse_click = _validate_get_proper(node_path)
	pass
	
func _validate_get_proper(node_path):
	if _is_valid_action_node_path(node_path):
		return node_path
	else:
		return null
	
func _is_valid_action_node_path(node_path): #bool
	if get_parent() == null: #before _ready
		return true
	if node_path == null:
		return false
		
	var node = get_node(node_path)
	return node != null and node.has_method("play_action") #support duck typing. :D

func _play_action_from_path(path):
	if path != null:
		var node = get_node(path)
		if node != null:
			node.play_action()
