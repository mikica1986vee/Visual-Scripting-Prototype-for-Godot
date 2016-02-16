extends "../Effects/BaseEffect.gd"

export var working_time = 1.0

var _working_timer = working_time

func add_on_prepare_effect(): #happens before delay
	print (get_name() + " add_on_prepare_effect()")
	pass
	
func add_on_start_effect(): #happens after delay
	print (get_name() + " add_on_start_effect()")
	_working_timer = working_time
	
	if _working_timer > 0:
		enable_effect() #if not called effect will finish automaticlly.
	pass
	
func add_on_process_effect(dt): #starts happening after delay, will be called AT LEAST once
	print (get_name() + " add_on_process_effect(" + str(dt) + ")")
	
	_working_timer += - dt
	
	if _working_timer < 0:
		effect_is_done() #must be called!
	pass
	
func add_on_effect_is_done():
	print (get_name() + " add_on_effect_is_done()")
	pass
	
func _do_fast_forward(): #must be overriden in derived classes!, should finish the effect in correct way
	print (get_name() + " _do_fast_forward()")
	#you don't need to call effect_is_done if fast forward is called
	pass
