tool
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

export var use_fixed_process = false

export var desc = "description here"
export(NodePath) var on_action_done_path setget _on_action_done_path_set

signal action_is_played(action)
signal action_is_done(action)

var _on_action_done = null

var action_done_callback = null

var _action_prepared = false

var _action_is_playing = false



#public

func enable_action():
	set_process(not use_fixed_process)
	set_fixed_process(use_fixed_process)
	add_on_enable_action()
	pass

func disable_action():
	set_process(false)
	set_fixed_process(false)
	add_on_disable_action()
	pass
	
func play_action(): #bool
	if not _action_prepared:
		_prepare_action()
		
	if _action_is_playing:
		fast_forward()
		
	var l_started = is_action_playable() and _do_play_action()
	
	if l_started:
		_action_is_playing = true
		emit_signal("action_is_played", self)
		if is_action_done():
			_action_is_done()
		else:
			enable_action()
	
	return l_started
	
func play_action_with_callback(target, method_name): #bool
	action_done_callback = ActionDoneCallback.new(target, method_name)
	var played = play_action()
	if not played:
		action_done_callback = null
		
	return played
	
func set_action_done_callback(target, method_name):
	action_done_callback = ActionDoneCallback.new(target, method_name)
	
func fast_forward():
	add_on_fast_forward()
	_action_is_done()
	
	if _on_action_done :
		_on_action_done.fast_forward()
	
	pass

#/public

#Template pattern stuff

func add_on_prepare_action():
	pass
	
func add_on_process_action(dt):
	pass
	
func add_on_enable_action():
	pass
	
func add_on_disable_action():
	pass
	
func add_on_action_done():
	pass
	
func add_on_fast_forward():
	pass

#/Template pattern stuff

#Abstract stuff

func is_action_done(): #bool
	assert(false) #must be overriden!
	return true;
	
func _do_play_action(): #bool
	assert(false) #must be overriden!
	return true
	
func is_action_playable(): #bool
	assert(false) #must be overriden!
	return true

#/Abstract stuff

#private stuff
func _ready():
	if not get_tree().is_editor_hint():
		_prepare_action()
	
func _prepare_action():
	if _action_prepared:
		return
		
	disable_action()
	add_on_prepare_action()
	
	if on_action_done_path:
		_on_action_done = get_node(on_action_done_path)
	
	_action_prepared = true
	pass
	
func _action_is_done():
	_action_is_playing = false
	disable_action()
	if action_done_callback:
		action_done_callback.call()
		action_done_callback = null
		
	if _on_action_done:
		_on_action_done.play_action()
	
	add_on_action_done()
	emit_signal("action_is_done", self)
	pass
	
func _process(delta):
	_process_action(delta)
	pass
	
func _fixed_process(delta):
	_process_action(delta)
	pass
	
func _process_action(dt):
	if is_action_done():
		_action_is_done()
		
	add_on_process_action(dt)
	pass
	
#Input validation
func _on_action_done_path_set(path):
	if path == null or path == "":
		on_action_done_path = null
		return
		
	if get_parent() == null:
		on_action_done_path = path
		return
		
	var action = get_node(path)
	
	if action != null and action != self and action is get_script():
		on_action_done_path = path
		_on_action_done = action
		pass
	else:
		on_action_done_path = null
	pass

class ActionDoneCallback:
	
	var target
	var method
	
	func call():
		if target != null and method != null:
			target.call(method)
		pass
		
	func _init(target, method_name):
		self.target = target
		self.method = method_name
	