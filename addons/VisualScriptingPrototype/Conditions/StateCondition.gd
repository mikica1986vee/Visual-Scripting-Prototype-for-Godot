
extends "BaseCondition.gd"

export var state = false setget set_state

signal state_set_to_true(condition)
signal state_set_to_false(condition)

var _condition_is_ready = false

func _ready():
	_condition_is_ready = true
	pass

func set_state(new_state):
	state = new_state
	if _condition_is_ready:
		if state:
			emit_signal("state_set_to_true", self)
		else:
			emit_signal("state_set_to_false", self)
	pass

func _is_really_fulfilled():
	return state
