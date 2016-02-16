
extends "BaseEffect.gd"

export(String) var text = ''
export var visible_in_logcat = false
export var prefix_with_path = false
	
func add_on_start_effect(): #happens after delay
	var prefix = ''
	if prefix_with_path:
		prefix = str(get_path())
		
	if visible_in_logcat:
		print (prefix, ': ', text)
	else:
		print(prefix + ': ' + text)
	
	effect_is_done()
	pass
	
func _do_fast_forward(): #must be overriden in derived classes!, should finish the effect in correct way
	#done what it needs to do in add_on_start_effect()
	pass


