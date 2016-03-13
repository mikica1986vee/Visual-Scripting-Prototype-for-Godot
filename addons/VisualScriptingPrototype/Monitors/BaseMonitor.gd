
extends Node

export var use_fixed_process = false
export var enable_at_start = true
	
func tracker_process(dt):
	pass

func add_on_ready():
	pass
	
func add_on_enable_tracking():
	pass
	
func add_on_disable_tracking():
	pass

func enable_tracking():
	set_fixed_process(use_fixed_process)
	set_process(not use_fixed_process)
	add_on_enable_tracking()
	pass
	
func disable_tracking():
	set_fixed_process(false)
	set_process(false)
	add_on_disable_tracking()
	pass

func _ready():
	add_on_ready()
	
	if enable_at_start:
		enable_tracking()
	pass
	
func _fixed_process(delta):
	tracker_process(delta)
	pass
	
func _process(delta):
	tracker_process(delta)
	pass
