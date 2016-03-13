
extends Node

const ValidationUtils = preload("../Utils/ValidationUtils.gd")

export var delay = 0.0

#public

func get_valid_path_with_property(node_path, property):
	return ValidationUtils.get_valid_path_with_property(self, node_path, property)
	
func get_valid_path_with_properties(node_path, properties):
	return ValidationUtils.get_valid_path_with_properties(self, node_path, properties)

func get_valid_path_with_method(node_path, method_name):
	return ValidationUtils.get_valid_path_with_method(self, node_path, method_name)
	
func get_valid_path_with_methods(node_path, method_names):
	return ValidationUtils.get_valid_path_with_methods(self, node_path, method_names)
	
func get_valid_path_with_class(node_path, class_name):
	return ValidationUtils.get_valid_path_with_class(self, node_path, class_name)
	
func enable_effect(): #must be called by derived classes in add_on_start_effect if they are done over time
	set_process(not _use_fixed_process)
	set_fixed_process(_use_fixed_process)
	add_on_enable_effect()
	pass
	
func disable_effect():
	set_process(false)
	set_fixed_process(false)
	add_on_disable_effect()
	pass

func effect_is_done(): #must be called by derived class if it called enable_effect. No need to call it during fast forward.
	disable_effect()
	add_on_effect_is_done()
	pass
	
func is_effect_done(): #bool #should be not is_effect_active()
	return not is_processing() and not is_fixed_processing()
	
func play_effect(use_fixed_process = false):
	_use_fixed_process = use_fixed_process
	_prepare_effect()
	_delay_timer = delay
	enable_effect()
	pass
	
func fast_forward():
	if not is_effect_done():
		if _delay_timer > 0:
			_delay_timer = 0
			_start_effect()
		_do_fast_forward()
		effect_is_done()
	pass
#/public

#template pattern stuff
func add_on_prepare_effect(): #happens only once, before delay
	pass
	
func add_on_start_effect(): #happens after delay every time effect is played
	pass
	
func add_on_process_effect(dt): #starts happening after delay, will be called only if you call enable_effect() in add_on_start_effect()
	pass
	
func add_on_effect_is_done():
	pass
	
func add_on_enable_effect():
	pass
	
func add_on_disable_effect():
	pass
#/template patter stuff

#abstract stuff

func _do_fast_forward():
	print('Script on ' + get_name() + ' does not override _do_fast_forward()')
	assert(false) #must be overriden in derived classes!
	pass

#/abstract stuff

#private stuff
var _delay_timer = 0.0
var _effect_prepared = false
var _use_fixed_process = false

func _ready():
	#_prepare_effect()
	pass

func _prepare_effect():
	if _effect_prepared:
		return
	_effect_prepared = true
	add_on_prepare_effect()
	pass
	
func _process(delta):
	_process_effect(delta)
	pass
	
func _fixed_process(delta):
	_process_effect(delta)
	pass

func _process_effect(dt):
	if _delay_timer >= 0:
		_delay_timer += -dt
		if _delay_timer < 0:
			disable_effect()
			_start_effect()
			if is_effect_done():
				effect_is_done()
			else:
				add_on_process_effect(-_delay_timer)
			pass
	else:
		add_on_process_effect(dt)
		pass
	pass
	
func _start_effect():
	add_on_start_effect()
	pass