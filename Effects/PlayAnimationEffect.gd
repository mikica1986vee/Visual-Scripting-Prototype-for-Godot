tool
extends "BaseAnimationEffect.gd"

export var animation_speed = 1.0
export var play_backwards = false

func do_animation_action():
	print("do_animation_action")
	if _target.has_animation(animation_name):
		_target.set_speed(animation_speed)
		
		if play_backwards:
			_target.play_backwards(animation_name)
		else:
			_target.play(animation_name)
	pass
	