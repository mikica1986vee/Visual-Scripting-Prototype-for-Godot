tool
extends "BaseAction.gd"

export(int, "AND", "OR") var op = 0
export var negate = false

var _conditions = []

func is_action_playable():
	var l_playable = (op == 0)
	if op == 0:	#AND
		for c in _conditions:
			l_playable = l_playable and c.is_fulfilled()
			if not l_playable:
				break
	else:		#OR
		for c in _conditions:
			l_playable = l_playable or c.is_fulfilled()
			if l_playable:
				break
	
	if negate:
		l_playable = not l_playable
		
	return l_playable or _conditions.empty()

func add_on_prepare_action():
	if _conditions != null and _conditions.size() != 0:
		return
	else:
		for c in get_children():
			if c.has_method("is_fulfilled"):
				_conditions.append(c)
	pass
