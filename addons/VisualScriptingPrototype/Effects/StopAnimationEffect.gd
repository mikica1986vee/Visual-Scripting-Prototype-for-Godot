tool
extends "BaseAnimationEffect.gd"

export(int, "finish", "rewind", "keep_position") var reset = 0
export var stop_playing_only = false

func do_animation_action():
	if stop_playing_only and not _target.is_playing():
		return
		
	if animation_name != null and animation_name != "":
		if _target.get_current_animation() == animation_name:
			_stop_animation()
	else:
		_stop_animation()
	pass
	
func _stop_animation():
	var cal = _target.get_current_animation_length()
	var cas = 0.0
	var l_speed = _target.get_speed()
	
	if l_speed < 0:
		cas = cal
		cal = 0.0
		
	if reset == 0: #finish
		_target.seek(cal, true)
	elif reset == 1: #rewind
		_target.seek(cas, true)
		
	_target.stop(true)