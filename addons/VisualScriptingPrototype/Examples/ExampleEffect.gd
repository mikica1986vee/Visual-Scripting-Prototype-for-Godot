tool #for verification
extends "../Effects/BaseEffect.gd"

export var working_time = 1.0
export(NodePath) var target_path setget _validate_target #validation example

var _working_timer = working_time

func add_on_prepare_effect(): #happens only once, before delay
	print (get_name() + " add_on_prepare_effect()")
	pass
	
func add_on_start_effect(): #happens after delay every time effect is played
	print (get_name() + " add_on_start_effect()")
	_working_timer = working_time
	
	if _working_timer > 0:
		enable_effect() #if not called effect will finish automaticlly.
	pass
	
func add_on_process_effect(dt): #starts happening after delay, will be called ONLY if enable_effect is called in add_on_start_effect
	print (get_name() + " add_on_process_effect(" + str(dt) + ")")
	
	_working_timer += - dt
	
	if _working_timer < 0:
		effect_is_done() #must be called if enable_effect was called!
	pass
	
func add_on_effect_is_done():
	print (get_name() + " add_on_effect_is_done()")
	pass
	
func _do_fast_forward(): #must be overriden in derived classes!, should finish the effect in correct way
	print (get_name() + " _do_fast_forward()")
	#you don't need to call effect_is_done if fast forward is called
	pass

func _validate_target(path):
	target_path = get_valid_path_with_method(path, "example_method") #when you only need one method
	if target_path == null:
		target_path = get_valid_path_with_methods(path, ['get_rot', 'set_rot', 'get_global_transform', 'set_global_transform']) #check for existance of all listed methods
	if target_path == null:
		target_path = get_valid_path_with_property(path, 'example_property') #checks for existance of property
	if target_path == null:
		target_path = get_valid_path_with_properties(path, ["alpha", "visibility"]) #checks for existance of all listed properties
	if target_path == null:
		target_path = get_valid_path_with_class(path, Node) #checks if object at path extends class