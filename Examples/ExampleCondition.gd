
extends "../Conditions/BaseCondition.gd"

export var is_true = true

func _is_really_fulfilled(): #ignore negation, it's done in base class
	return is_true
