
extends Node

export var use_fixed_process = false
export var desc = "description here"
export var negate = false

func is_fulfilled():
	if negate:
		return not _is_really_fulfilled()
	else:
		return _is_really_fulfilled()
		
func _is_really_fulfilled():
	assert(false) #override in derived classes
